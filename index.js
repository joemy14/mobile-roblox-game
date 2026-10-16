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

const ai = new OpenAI({
  apiKey: process.env.AI_API_KEY,
  baseURL: 'https://openrouter.ai/api/v1',
});
const gh = new Octokit({ auth: process.env.GITHUB_PAT });

// Load the AI's instructions and knowledge from the repo
function readRepoFile(p) {
  return fs.existsSync(path.join(__dirname, p))
    ? fs.readFileSync(path.join(__dirname, p), 'utf8')
    : '';
}

function buildSystemPrompt() {
  const knowledge = ['knowledge/mobile-rules.md', 'knowledge/simulator-playbook.md']
    .map(p => `--- ${p} ---\n${readRepoFile(p)}`)
    .join('\n\n');
  return `${readRepoFile('prompts/system.md')}\n\n${knowledge}`;
}

// Read a file from GitHub, or return '' if it doesn't exist yet
async function getFile(filePath) {
  try {
    const { data } = await gh.repos.getContent({
      owner: OWNER, repo: REPO, path: filePath, ref: BRANCH,
    });
    return Buffer.from(data.content, 'base64').toString('utf8');
  } catch (err) {
    if (err.status === 404) return '';
    throw err;
  }
}

// Commit a file to GitHub, creating it if needed
async function saveFile(filePath, content, message) {
  let sha;
  try {
    const { data } = await gh.repos.getContent({
      owner: OWNER, repo: REPO, path: filePath, ref: BRANCH,
    });
    sha = data.sha;
  } catch (err) {
    if (err.status !== 404) throw err;
  }
  await gh.repos.createOrUpdateFileContents({
    owner: OWNER, repo: REPO, path: filePath, branch: BRANCH,
    message, sha,
    content: Buffer.from(content, 'utf8').toString('base64'),
  });
}

// Make sure every path the AI returns is inside src/
function isSafePath(p) {
  return typeof p === 'string' && p.startsWith('src/') && !p.includes('..');
}

app.post('/api/build', async (req, res) => {
  const { prompt } = req.body || {};
  if (!prompt || typeof prompt !== 'string') {
    return res.status(400).json({ error: 'Send a "prompt" string.' });
  }

  try {
    // Give the AI the current code so it updates instead of overwriting
    const currentFiles = {};
    for (const p of ['src/shared/Config.luau', 'src/main.server.luau']) {
      currentFiles[p] = await getFile(p);
    }
    const context = Object.entries(currentFiles)
      .map(([p, c]) => `--- ${p} ---\n${c || '(file does not exist yet)'}`)
      .join('\n\n');

    const completion = await ai.chat.completions.create({
      model: MODEL,
      temperature: 0.4,
      messages: [
        { role: 'system', content: buildSystemPrompt() },
        {
          role: 'user',
          content: `Current code:\n${context}\n\nRequest: ${prompt}\n\nReturn only the JSON described in the rules.`,
        },
      ],
    });

    if (!completion.choices || completion.choices.length === 0) {
  console.error('AI provider response:', JSON.stringify(completion));
  const reason = completion.error?.message || 'the AI provider returned no answer (likely busy or rate-limited)';
  return res.status(502).json({ error: 'AI error: ' + reason });
}
const raw = completion.choices[0].message.content || '';
    const cleaned = raw.replace(/^```(json)?\s*/i, '').replace(/```\s*$/, '').trim();

    let parsed;
    try {
      parsed = JSON.parse(cleaned);
    } catch {
      return res.status(502).json({ error: 'AI returned invalid JSON. Try again.', raw });
    }

    const files = (parsed.files || []).filter(f => isSafePath(f.path) && typeof f.content === 'string');
    if (files.length === 0) {
      return res.status(502).json({ error: 'AI returned no valid files.', raw });
    }

    for (const f of files) {
      await saveFile(f.path, f.content, `AI: ${prompt.slice(0, 60)}`);
    }

    res.json({
      ok: true,
      written: files.map(f => f.path),
      note: 'Changes are on the ai-restructure branch. Check the Actions tab for the deploy.',
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message });
  }
});

app.get('/health', (_, res) => res.json({ ok: true, branch: BRANCH }));

app.listen(PORT, () => console.log(`Running on port ${PORT}`));
