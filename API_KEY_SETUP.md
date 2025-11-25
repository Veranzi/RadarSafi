# Google Gemini API Key Setup Guide

## 📋 How to Use the API Key

### Step 1: Get Your API Key

⚠️ **IMPORTANT:** You must get your own API key from Google Cloud Console. Never use someone else's API key or commit your key to version control.

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable the **Generative Language API**
4. Go to **APIs & Services** → **Credentials**
5. Click **Create Credentials** → **API Key**
6. Copy your API key (it will look like: `AIzaSy...` followed by alphanumeric characters)
7. **IMPORTANT:** Never share this key or commit it to version control

### Step 2: Create `.env` File

Create a `.env` file in the **root directory** of your project (same level as `pubspec.yaml`):

```env
# Google API Configuration
GOOGLE_API_KEY=YOUR_API_KEY_HERE
```

⚠️ **IMPORTANT:** Replace `YOUR_API_KEY_HERE` with your actual API key from Google Cloud Console

### Step 2: Verify File Location

Make sure your `.env` file is in:
```
RadarSafi/
├── .env              ← HERE (root directory)
├── pubspec.yaml
├── lib/
└── ...
```

### Step 3: Verify `pubspec.yaml` Configuration

The `.env` file should already be listed in `pubspec.yaml` under assets:

```yaml
flutter:
  assets:
    - .env
```

### Step 4: Restart the App

⚠️ **IMPORTANT:** Hot reload does NOT reload `.env` files!

You must do a **full restart**:
- Stop the app completely
- Run `flutter run` again
- Or use "Restart" (not "Hot Reload")

---

## 🔧 How It Works in the App

### 1. Loading the API Key

The API key is loaded in `lib/main.dart`:

```dart
await dotenv.load(fileName: ".env");
```

### 2. Accessing the API Key

The API key is accessed through `ApiConfig`:

```dart
import 'package:radarsafi/src/core/config/api_config.dart';

// Get the API key
final apiKey = ApiConfig.googleApiKey;

// Validate it's configured
ApiConfig.validate();
```

### 3. Where It's Used

The API key is used in these services:

- **`ChatbotService`** - For chatbot responses
- **`LLMService`** - For content verification (images, links, phone numbers, emails)
- **`VerificationService`** - For scam detection

---

## 🌐 API Endpoints Used

### Current Configuration:

**Base URL:** `https://generativelanguage.googleapis.com/v1beta/models`

**Model:** `gemini-2.0-flash-001`

**Endpoints:**
- Chatbot: `v1beta/models/gemini-2.0-flash-001:generateContent`
- Image Analysis: `v1beta/models/gemini-2.0-flash-001:generateContent`
- Link Analysis: `v1beta/models/gemini-2.0-flash-001:generateContent`
- Phone Analysis: `v1beta/models/gemini-2.0-flash-001:generateContent`
- Email/Message Analysis: `v1beta/models/gemini-2.0-flash-001:generateContent`

**Authentication Method:** Header authentication
```dart
headers: {
  'Content-Type': 'application/json',
  'x-goog-api-key': apiKey,
}
```

---

## ✅ Testing the API Key

### Test in Terminal (PowerShell):

```powershell
$headers = @{'Content-Type'='application/json'; 'x-goog-api-key'='YOUR_API_KEY_HERE'}
$body = @{contents=@(@{parts=@(@{text='Hello, test'})})} | ConvertTo-Json -Depth 10
Invoke-RestMethod -Uri 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-001:generateContent' -Method Post -Headers $headers -Body $body
```

⚠️ **Replace `YOUR_API_KEY_HERE` with your actual API key**

### Expected Response:
```json
{
  "candidates": [{
    "content": {
      "parts": [{
        "text": "Hello! How can I help you?"
      }]
    }
  }]
}
```

---

## 🔒 Security Best Practices

1. ✅ **Never commit `.env` to git** (already in `.gitignore`)
2. ✅ **Never share API keys publicly**
3. ✅ **Don't put API keys in documentation files**
4. ✅ **Rotate keys if exposed**

---

## 🚨 Troubleshooting

### Error: "API key expired"
- The API key might have been disabled
- Get a new key from Google Cloud Console
- Update `.env` file
- **Do a full restart** (not hot reload)

### Error: "API key not configured"
- Check `.env` file exists in root directory
- Check `GOOGLE_API_KEY=` line is correct
- Check `pubspec.yaml` includes `.env` in assets
- **Do a full restart**

### Error: "404 Not Found"
- Enable "Generative Language API" in Google Cloud Console
- Verify API key has proper permissions

### Error: "403 Permission Denied"
- API key might be restricted
- Check API key restrictions in Google Cloud Console
- Ensure "Generative Language API" is enabled

---

## 📝 Quick Reference

**API Key:** Get your own from [Google Cloud Console](https://console.cloud.google.com/)

**Model:** `gemini-2.0-flash-001`

**API Version:** `v1beta`

**File Location:** `.env` (root directory)

**Load in:** `lib/main.dart` (line 14)

**Access via:** `ApiConfig.googleApiKey`

---

## 🔄 If You Need a New API Key

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Navigate to **APIs & Services** → **Credentials**
3. Click **Create Credentials** → **API Key**
4. Enable **Generative Language API** for the key
5. Update `.env` file with new key
6. **Full restart** the app

