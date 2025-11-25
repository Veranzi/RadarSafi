# Firestore Setup Guide

## 🔥 Current Issue: Permission Denied

If you're seeing "Failed to save report: permission-denied" error, you need to set up Firestore security rules.

---

## ✅ Quick Fix: Set Up Firestore Security Rules

### Option 1: Using Firebase Console (Easiest)

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: **radarsafi**
3. Navigate to **Firestore Database** → **Rules** tab
4. Replace the default rules with:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Reports collection - authenticated users can create and read their own reports
    match /reports/{reportId} {
      // Allow read if user is authenticated and owns the report
      allow read: if request.auth != null && 
                     (request.auth.uid == resource.data.userId || 
                      request.auth.uid == request.resource.data.userId);
      
      // Allow create if user is authenticated
      allow create: if request.auth != null && 
                       request.auth.uid == request.resource.data.userId;
      
      // Allow update/delete only if user owns the report
      allow update, delete: if request.auth != null && 
                               request.auth.uid == resource.data.userId;
    }
  }
}
```

5. Click **Publish**

---

### Option 2: Using Firebase CLI

1. Install Firebase CLI:
   ```bash
   npm install -g firebase-tools
   ```

2. Login to Firebase:
   ```bash
   firebase login
   ```

3. Initialize Firebase in your project:
   ```bash
   firebase init firestore
   ```

4. Deploy the rules:
   ```bash
   firebase deploy --only firestore:rules
   ```

---

## 🔒 Security Rules Explained

### Current Rules:
- ✅ **Authenticated users** can create reports
- ✅ Users can **read their own reports** only
- ✅ Users can **update/delete their own reports** only
- ❌ Unauthenticated users **cannot access** reports

### Rule Breakdown:

```javascript
allow create: if request.auth != null && 
                 request.auth.uid == request.resource.data.userId;
```
- User must be logged in (`request.auth != null`)
- The `userId` in the report must match the logged-in user's ID

```javascript
allow read: if request.auth != null && 
               request.auth.uid == resource.data.userId;
```
- User must be logged in
- Can only read reports where `userId` matches their own

---

## 🚨 Common Issues

### Issue 1: "Permission Denied"
**Solution:** 
- Make sure Firestore security rules are published
- Verify user is logged in
- Check that rules allow the operation

### Issue 2: "Firestore not initialized"
**Solution:**
- Check `FirebaseConfig.initialize()` is called in `main.dart`
- Verify Firebase project ID matches: `radarsafi`

### Issue 3: "User not authenticated"
**Solution:**
- User must be logged in to save reports
- Check authentication state in the app

---

## 📝 Testing

After setting up rules, test by:

1. **Login** to the app
2. **Navigate** to Report screen
3. **Submit** a report
4. **Check** if it saves successfully

---

## 🔐 For Development (Temporary - Less Secure)

If you want to test quickly, you can use these **less secure** rules (NOT for production):

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

⚠️ **Warning:** These rules allow any authenticated user to read/write all documents. Only use for development!

---

## ✅ Production Rules (Recommended)

The rules in `firestore.rules` file are production-ready:
- Users can only access their own reports
- Proper authentication checks
- Secure and scalable

---

## 📍 File Locations

- **Security Rules File:** `firestore.rules` (in project root)
- **Firebase Config:** `lib/src/core/config/firebase_config.dart`
- **Reports Service:** `lib/src/core/services/reports_service.dart`

---

## 🎯 Next Steps

1. ✅ Set up Firestore security rules (use Option 1 above)
2. ✅ Publish the rules
3. ✅ Test saving a report
4. ✅ Verify it works!

