const express = require('express');
const cors = require('cors'); // This was missing before!
const { OpenAI } = require('openai');
const { Octokit } = require('@octokit/rest');

const app = express();

// Setup Middleware
app.use(cors()); // Allow browser to talk to server
app.use(express.json());
app.use(express.static('public'));

console.log("✅ Server starting...");

// Setup AI (Using the free Nvidia model you found)
const ai = new OpenAI({
  baseURL: "https://openrouter.ai/api/v1",
  apiKey: process.env.AI_API_KEY
});

// Setup GitHub
const octokit = new Octokit({ auth: process.env.GITHUB_PAT });
const owner = process.env.GITHUB_OWNER;
const repo = process.env.GITHUB_REPO;

// The Magic Endpoint
app.post('/api/build', async (req, res) => {
  console.log("🔥 Request received!");
  console.log("Prompt:", req.body.prompt);
  console.log("File Path:", req.body.filePath);
  
  try {
    console.log("⏳ Asking AI...");
    const response = await ai.chat.completions.create({
      model: "nvidia/nemotron-3-ultra-550b-a55b:free", 
      messages: [{ 
        role: "user", 
        content: `Write ONLY valid Roblox Luau code for this request: ${req.body.prompt}. Do not use markdown code blocks. Output raw text only.` 
      }]
    });
    
    let code = response.choices[0].message.content;
    code = code.replace(/```luau/g, '').replace(/```/g, '').trim();
    console.log("✅ AI done. Length:", code.length);

    // GitHub Logic
    let sha = null;
    try {
      const { data } = await octokit.repos.getContent({ owner, repo, path: req.body.filePath });
      sha = data.sha;
      console.log("File exists, got SHA");
    } catch(e) { 
      console.log("New file, no SHA needed"); 
    }

    console.log("⏳ Pushing to GitHub...");
    await octokit.repos.createOrUpdateFileContents({
      owner, repo, path: req.body.filePath,
      message: `AI Update: ${req.body.prompt.substring(0, 30)}...`,
      content: Buffer.from(code).toString('base64'),
      sha: sha
    });
    console.log("✅ Pushed to GitHub!");

    // ALWAYS send a success response
    res.json({ success: true, message: "✅ Success! Check GitHub Actions." });
  } catch (err) {
    console.error("❌ CRITICAL ERROR:", err.message);
    // ALWAYS send an error response
    res.status(500).json({ success: false, error: err.message });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`🚀 Running on port ${PORT}`));
