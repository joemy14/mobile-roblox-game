const express = require('express');
const cors = require('cors');
const path = require('path');
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
const MODEL = process.env.AI_MODEL || 'google/gemma-4-26b-a4b-it:free';

const ai = new OpenAI({
  apiKey: process.env.AI_API_KEY,
  baseURL: 'https://openrouter.ai/api/v1',
  timeout: 150000,
  maxRetries: 0,
});
const gh = new Octokit({ auth: process.env.GITHUB_PAT });

// Only allow editing inside src/
function isSafePath(p) {
  return typeof p === 'string' && p.startsWith('src/') && !p.includes('..');
}

// Read one file from the branch, or '' if it doesn't exist yet
async function readFile(p) {
  try {
    const { data } = await gh.repos.getContent({ owner: OWNER, repo: REPO, path: p, ref: BRANCH });
    return Buffer.from(data.content, 'base64').toString('utf8');
  } catch (err) {
    if (err.status === 404) return '';
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

// Remove code fences if the model added them anyway
function clean(text) {
  return text.replace(/^```[a-z]*\s*\n?/i, '').replace(/\n?```\s*$/, '').trim() + '\n';
}

app.post('/api/build', async (req, res) => {
  const { prompt, filePath } = req.body || {};
  if (!prompt || typeof prompt !== 'string') {
    return res.status(400).json({ error: 'Send a "prompt" string.' });
  }
  if (!isSafePath(filePath)) {
    return res.status(400).json({ error: 'File path must start with src/ (example: src/shared/Config.luau).' });
  }

  try {
    const original = await readFile(filePath);

    const completion = await ai.chat.completions.create({
      model: MODEL,
      temperature: 0.1,
      messages: [
        {
          role: 'system',
                    content:
            'You maintain a Roblox Luau project. You receive a file path, the CURRENT file content ' +
            '(may be empty), and a CODE SNIPPET to add. Decide what to do: ' +
            '(a) If the file is empty or new, create it containing the snippet. ' +
            '(b) If the file exists, insert the snippet where it fits, usually at the end. ' +
            'Replace an existing block only if the snippet is clearly meant to replace it. ' +
            'Never duplicate code that already exists. Keep every existing line, position, size, and color. ' +
            'Output ONLY the complete updated file. No explanations, no markdown.',
        },
        {
          role: 'user',
          content: `File: ${filePath}\n----- FILE START -----\n${original || '(empty, new file)'}\n----- FILE END -----\n\nChange request:\n${prompt}`,
        },
      ],
    });

    if (!completion.choices || completion.choices.length === 0) {
      return res.status(502).json({
        error: 'AI gave no answer: ' + (completion.error?.message || 'busy or rate-limited. Try again shortly.'),
      });
    }

    const updated = clean(completion.choices[0].message.content || '');

    // Safety: refuse if the model deleted most of the file
    if (original.length > 200 && updated.length < original.length * 0.6) {
      return res.status(502).json({
        error: `Rejected: the AI output is much shorter than the file (${updated.length} vs ${original.length} characters). Nothing was saved. Try a smaller request.`,
      });
    }

    await saveFile(filePath, updated, `AI edit ${filePath}: ${prompt.slice(0, 50)}`);

    res.json({
      ok: true,
      written: filePath,
      note: 'Saved to ai-restructure. Check the Actions tab for the deploy.',
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message });
  }
});

app.get('/health', (_, res) => res.json({ ok: true, branch: BRANCH, model: MODEL }));

app.listen(PORT, () => console.log(`Running on port ${PORT}`));
