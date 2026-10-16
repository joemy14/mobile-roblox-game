const express = require('express');
const cors = require('cors');
const path = require('path');
const fs = require('fs');
const OpenAI = require('openai');
const { Octokit } = require('@octokit/rest');

const app = express();
app.use(cors());
app.use(express.json({ limit: '1mb' }));
app.use(express.static(__dirname));

const PORT = process.env.PORT || 10000;
const OWNER = process.env.GITHUB_OWNER;
const REPO = process.env.GITHUB_REPO;
const BRANCH = process.env.GITHUB_BRANCH || 'ai-restructure';
const MODEL = 'nvidia/nemotron-3-ultra-550b-a55b:free';
const MAX_FILE_CHARS = 30000;

const ai = new OpenAI({
  apiKey: process.env.AI_API_KEY,
  baseURL: 'https://openrouter.ai/api/v1',
  timeout: 150000,
  maxRetries: 0,
});
const gh = new Octokit({ auth: process.env.GITHUB_PAT });

function readLocal(p) {
  const full = path.join(__dirname, p);
  return fs.existsSync(full) ? fs.readFileSync(full, 'utf8') : '';
}

function rules() {
  return [readLocal('prompts/system.md'), readLocal('knowledge/mobile-rules.md')].join('\n\n');
}

async function ask(system, user) {
  const c = await ai.chat.completions.create({
    model: MODEL,
    temperature: 0.2,
    messages: [
      { role: 'system', content: system },
      { role: 'user', content: user },
    ],
  });
  if (!c.choices || c.choices.length === 0) {
    throw new Error('AI gave no answer: ' + (c.error?.message || 'busy or rate-limited. Try again in a few minutes.'));
  }
  return c.choices[0].message.content || '';
}

function parseJson(text) {
  const s = text.indexOf('{');
  const e = text.lastIndexOf('}');
  if (s === -1 || e === -1) throw new Error('AI reply had no JSON');
  return JSON.parse(text.slice(s, e + 1));
}

function isSafePath(p) {
  return typeof p === 'string' && p.startsWith('src/') && !p.includes('..');
}

// List every file under src/ on the branch (paths only, no content)
async function listSrc() {
  const { data: ref } = await gh.git.getRef({ owner: OWNER, repo: REPO, ref: `heads/${BRANCH}` });
  const { data: tree } = await gh.git.getTree({
    owner: OWNER, repo: REPO, tree_sha: ref.object.sha, recursive: 'true',
  });
  return tree.tree.filter(t => t.type === 'blob' && t.path.startsWith('src/')).map(t => t.path);
}

// Read one file's text, or null if it doesn't exist
async function readFile(p) {
  try {
    const { data } = await gh.repos.getContent({ owner: OWNER, repo: REPO, path: p, ref: BRANCH });
    return Buffer.from(data.content, 'base64').toString('utf8').slice(0, MAX_FILE_CHARS);
  } catch (err) {
    if (err.status === 404) return null;
    throw err;
  }
}

// Create or update one file on the branch
async function saveFile(filePath, content, message) {
  let sha;
  try {
    const { data } = await gh.repos.getContent({ owner: OWNER, repo: REPO, path: filePath, ref: BRANCH });
    sha = data.sha;
  } catch (err) {
    if (err.status !== 404) throw err;
  }
  await gh.repos.createOrUpdateFileContents({
    owner: OWNER, repo: REPO, path: filePath, branch: BRANCH, message, sha,
    content: Buffer.from(content, 'utf8').toString('base64'),
  });
}

app.post('/api/build', async (req, res) => {
  const { prompt } = req.body || {};
  if (!prompt || typeof prompt !== 'string') {
    return res.status(400).json({ error: 'Send a "prompt" string.' });
  }

  try {
    // Step 1: AI finds the files it needs (paths only, fast)
    const allPaths = await listSrc();
    const locateReply = await ask(
      'You search a Roblox game repo. You get a list of file paths and a request. ' +
      'Pick up to 6 existing files that must be read to make the change. ' +
      'Return ONLY JSON: {"read": ["src/..."]}. No other text.',
      `Files:\n${allPaths.join('\n') || '(none yet)'}\n\nRequest: ${prompt}`
    );
    const wanted = (parseJson(locateReply).read || [])
      .filter(p => allPaths.includes(p))
      .slice(0, 6);

    // Step 2: read those files
    const working = {};
    for (const p of wanted) {
      const content = await readFile(p);
      if (content !== null) working[p] = content;
    }
    const context = Object.entries(working)
      .map(([p, c]) => `--- ${p} ---\n${c}`)
      .join('\n\n') || '(no matching files yet)';

    // Step 3: AI returns small find/replace edits, or new files
    const editReply = await ask(
      `${rules()}\n\nYou edit Roblox Luau files. Return ONLY JSON, no other text:\n` +
      `{"edits":[{"path":"src/...","find":"exact text copied from the file","replace":"new text"}],` +
      `"create":[{"path":"src/...","content":"full file"}]}\n` +
      `Rules: "find" must match the file exactly (same spaces and tabs) and appear only once. ` +
      `Keep each edit small. Use "create" only for brand new files. Paths must start with src/.`,
      `Files:\n${context}\n\nRequest: ${prompt}`
    );
    const plan = parseJson(editReply);

    // Step 4: apply the edits safely on the server
    const problems = [];
    const changed = new Set();

    for (const e of plan.edits || []) {
      if (!isSafePath(e.path)) { problems.push(`bad path: ${e.path}`); continue; }
      const current = working[e.path];
      if (current === undefined) { problems.push(`not read: ${e.path}`); continue; }
      if (!e.find) { problems.push(`empty find in ${e.path}`); continue; }
      const count = current.split(e.find).length - 1;
      if (count !== 1) { problems.push(`${e.path}: find text found ${count} times`); continue; }
      working[e.path] = current.replace(e.find, () => e.replace || '');
      changed.add(e.path);
    }

    for (const f of plan.create || []) {
      if (!isSafePath(f.path) || typeof f.content !== 'string') { problems.push(`bad create: ${f.path}`); continue; }
      working[f.path] = f.content;
      changed.add(f.path);
    }

    if (changed.size === 0) {
      return res.status(502).json({ error: 'No changes could be applied.', problems, readFiles: wanted });
    }

    // Step 5: commit changed files
    for (const p of changed) {
      await saveFile(p, working[p], `AI: ${prompt.slice(0, 60)}`);
    }

    res.json({
      ok: true,
      read: wanted,
      written: [...changed],
      problems,
      note: 'Changes are on ai-restructure. Check the Actions tab for the deploy.',
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message });
  }
});

app.get('/health', (_, res) => res.json({ ok: true, branch: BRANCH, model: MODEL }));

app.listen(PORT, () => console.log(`Running on port ${PORT}`));
