const express = require('express');
const cors = require('cors');
const { OpenAI } = require('openai');
const { Octokit } = require('@octokit/rest');

const app = express();
app.use(cors());
app.use(express.json());
app.get('/', (req, res) => {
     res.sendFile(__dirname + '/index.html');
   });

console.log("✅ Smart Builder Server starting...");

const ai = new OpenAI({
  baseURL: "https://openrouter.ai/api/v1",
  apiKey: process.env.AI_API_KEY
});

const octokit = new Octokit({ auth: process.env.GITHUB_PAT });
const owner = process.env.GITHUB_OWNER;
const repo = process.env.GITHUB_REPO;

app.post('/api/build', async (req, res) => {
  console.log("🔥 Request received!");
  const { prompt, filePath } = req.body;
  
  try {
    // 1. READ: Check if file exists and get current code
    let currentCode = "";
    let sha = null;
    
    try {
      const { data } = await octokit.repos.getContent({ owner, repo, path: filePath });
      sha = data.sha;
      // Decode the Base64 content from GitHub
      currentCode = Buffer.from(data.content, 'base64').toString('utf-8');
      console.log("🧠 Memory loaded! Existing code length:", currentCode.length);
    } catch (e) {
      console.log("📄 New file created. No memory yet.");
    }

    // 2. THINK: Create a smart prompt
    let aiPrompt = "";
    if (currentCode.length > 0) {
      aiPrompt = `You are an expert Roblox Luau developer. 
      
Here is the CURRENT code in the file:
\`\`\`luau
${currentCode}
\`\`\`

USER REQUEST: "${prompt}"

INSTRUCTIONS:
1. Update the code above to fulfill the user request.
2. CRITICAL: Do NOT delete existing features unless asked. Keep the game working.
3. Return the COMPLETE, updated file. Do not just return the new lines.
4. Output ONLY the raw code. No markdown blocks.`;
    } else {
      aiPrompt = `Write a complete Roblox Luau script for this request: "${prompt}". Output ONLY raw code.`;
    }

    console.log(" Asking AI with memory...");
    
    // 3. WRITE: Get the new code
    const response = await ai.chat.completions.create({
      model: "nvidia/nemotron-3-ultra-550b-a55b:free", 
      messages: [{ role: "user", content: aiPrompt }]
    });
    
    let newCode = response.choices[0].message.content;
    // Clean up any accidental markdown
    newCode = newCode.replace(/```luau/g, '').replace(/```/g, '').trim();
    console.log("✅ AI generated new code. Length:", newCode.length);

    // 4. SAVE: Push to GitHub
    await octokit.repos.createOrUpdateFileContents({
      owner, repo, path: filePath,
      message: `AI Update: ${prompt.substring(0, 30)}...`,
      content: Buffer.from(newCode).toString('base64'),
      sha: sha // This tells GitHub we are updating, not overwriting blindly
    });
    
    console.log("✅ Pushed to GitHub!");
    res.json({ success: true, message: "✅ Code updated with memory!" });

  } catch (err) {
    console.error("❌ Error:", err.message);
    res.status(500).json({ success: false, error: err.message });
  }
});

const PORT = process.env.PORT || 10000;
app.listen(PORT, () => console.log(`🚀 Running on port ${PORT}`));
