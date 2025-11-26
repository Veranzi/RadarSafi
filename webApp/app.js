// Configuration
const API_MODEL = "gemini-1.5-flash"; 

// --- Auth & Session Management ---
function checkAuth() {
    const user = localStorage.getItem('fwk_user');
    // If no user and we are NOT on index.html, kick them out
    if (!user && !window.location.pathname.endsWith('index.html') && !window.location.pathname.endsWith('/')) {
        window.location.href = 'index.html';
    }
    // Update UI if user exists
    if (user && document.getElementById('user-display-name')) {
        document.getElementById('user-display-name').textContent = JSON.parse(user).name;
    }
    // Restore API Key if saved
    const savedKey = localStorage.getItem('fwk_api_key');
    const keyInput = document.getElementById('api-key-input');
    if (savedKey && keyInput) {
        keyInput.value = savedKey;
    }
}

function logout() {
    localStorage.removeItem('fwk_user');
    localStorage.removeItem('fwk_api_key');
    window.location.href = 'index.html';
}

// --- Gemini AI Logic ---
function getApiKey() {
    const keyInput = document.getElementById('api-key-input');
    if (!keyInput || !keyInput.value) {
        alert("Please enter your Gemini API Key in the header.");
        return null;
    }
    // Save key for other pages
    localStorage.setItem('fwk_api_key', keyInput.value);
    return keyInput.value;
}

async function callGeminiAPI(prompt, base64Image = null, useGrounding = false) {
    const apiKey = getApiKey();
    if (!apiKey) return null;

    const loader = document.getElementById('loading-indicator');
    if (loader) loader.classList.remove('hidden');
    
    const API_URL = `https://generativelanguage.googleapis.com/v1beta/models/${API_MODEL}:generateContent?key=${apiKey}`;
    let parts = [{ "text": prompt }];
    
    if (base64Image) {
        parts.push({ "inlineData": { "mimeType": "image/jpeg", "data": base64Image } });
    }

    let payload = { "contents": [{"parts": parts}] };
    if (useGrounding) payload.tools = [{ "google_search": {} }];

    try {
        const response = await fetch(API_URL, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        });
        const result = await response.json();
        const candidate = result.candidates?.[0];
        
        if (candidate) {
            let text = candidate.content.parts[0].text;
            let sources = candidate.groundingMetadata?.groundingAttributions?.map(s => ({uri: s.web?.uri, title: s.web?.title})).filter(s => s.uri) || [];
            return { text, sources };
        }
    } catch (error) {
        console.error(error);
        alert("AI Error: Check console for details.");
        return null;
    } finally {
        if (loader) loader.classList.add('hidden');
    }
}

function renderMarkdown(text) {
    if (typeof marked === 'undefined') return text;
    return marked.parse(text.replace(/</g, "&lt;").replace(/>/g, "&gt;"));
}

// Run Auth Check on Load
document.addEventListener('DOMContentLoaded', () => {
    checkAuth();
    const logoutBtn = document.getElementById('logout-btn');
    if(logoutBtn) logoutBtn.addEventListener('click', logout);
});
