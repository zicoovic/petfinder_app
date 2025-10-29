# Firebase App Distribution Reference Guide 🔥

Complete guide for distributing your PetFinder App using Firebase App Distribution and GitHub Actions.

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [Initial Setup (One-Time)](#initial-setup-one-time)
3. [Adding New Testers](#adding-new-testers)
4. [How to Distribute New Versions](#how-to-distribute-new-versions)
5. [Troubleshooting](#troubleshooting)
6. [Customer Instructions](#customer-instructions)
7. [iOS Setup (Future)](#ios-setup-future)
8. [Useful Links](#useful-links)

---

## 🎯 Overview

### What is Firebase App Distribution?

Firebase App Distribution allows you to:
- ✅ Automatically send APKs to testers via email
- ✅ Track which testers have downloaded the app
- ✅ Collect feedback from testers
- ✅ Manage multiple testing groups
- ✅ Distribute beta versions before Play Store release

### Current Setup

- **Platform:** Android only
- **Project:** angular-amp-421409
- **App ID:** `1:977811551855:android:8897af1ee365c44c037f9a`
- **Package Name:** `com.example.petfinder_app`
- **Automation:** GitHub Actions (runs on push to main/develop)

---

## 🚀 Initial Setup (One-Time)

### Prerequisites Checklist

- [x] Firebase project created
- [x] Android app registered in Firebase
- [x] `google-services.json` added to project
- [x] Firebase plugins configured in Gradle
- [x] Service account key created
- [x] GitHub secrets added
- [x] GitHub Actions workflow created
- [x] "testers" group created in Firebase

### Files Modified/Created

```
petfinder_app/
├── .github/
│   └── workflows/
│       └── build-and-distribute.yml  ← Workflow file
├── android/
│   ├── app/
│   │   ├── google-services.json      ← Firebase config
│   │   └── build.gradle.kts          ← Updated with plugin
│   └── settings.gradle.kts           ← Updated with plugin
└── FIREBASE_DISTRIBUTION_GUIDE.md    ← This file
```

### GitHub Secrets

Located at: https://github.com/zicoovic/petfinder_app/settings/secrets/actions

| Secret Name | Description | Example Value |
|-------------|-------------|---------------|
| `FIREBASE_APP_ID` | Firebase Android App ID | `1:123:android:abc123` |
| `FIREBASE_SERVICE_ACCOUNT` | Service account JSON | `{"type": "service_account"...}` |

---

## 👥 Adding New Testers

### Method 1: Via Firebase Console (Recommended)

1. **Go to Firebase Console:**
   - https://console.firebase.google.com/project/angular-amp-421409/appdistribution/testers

2. **Add Tester:**
   - Click **"Add testers"**
   - Enter tester's email address
   - Select **"testers"** group
   - Click **"Add"**

3. **That's it!**
   - Next time you push code, they'll get an email
   - No need to re-run workflow

### Method 2: Via Firebase CLI

```bash
# Install Firebase CLI (one-time)
npm install -g firebase-tools

# Login
firebase login

# Add tester
firebase appdistribution:testers:add customer@example.com \
  --project angular-amp-421409 \
  --group testers
```

### Send Existing APK to New Tester

**Option A: Manual Distribution**
1. Go to: https://console.firebase.google.com/project/angular-amp-421409/appdistribution
2. Click on latest release
3. Click **"Distribute"**
4. Select new tester
5. Click **"Distribute"**

**Option B: Re-run GitHub Action**
1. Go to: https://github.com/zicoovic/petfinder_app/actions
2. Click latest successful run
3. Click **"Re-run all jobs"**

**Option C: Push Empty Commit**
```bash
git commit --allow-empty -m "chore: redistribute to new testers"
git push origin main
```

---

## 📦 How to Distribute New Versions

### Automatic Distribution (Recommended)

Every time you push to `main` or `develop` branch:

```bash
# Make your changes
git add .
git commit -m "feat: add new feature"
git push origin main  # or develop
```

**What happens automatically:**
1. ✅ GitHub Actions triggers
2. ✅ Flutter tests run
3. ✅ APK builds
4. ✅ APK uploads to Firebase
5. ✅ All testers in "testers" group receive email
6. ✅ Email contains download link

**Timeline:**
- Build takes: 5-10 minutes
- Email arrives: Immediately after build
- Tester downloads: Anytime (link doesn't expire)

### Manual Distribution

If you want to distribute without pushing code:

**Option 1: Build Locally**
```bash
# Build APK
flutter build apk --release

# Upload using Firebase CLI
firebase appdistribution:distribute \
  build/app/outputs/flutter-apk/app-release.apk \
  --app 1:977811551855:android:8897af1ee365c44c037f9a \
  --groups "testers" \
  --release-notes "Bug fixes and improvements"
```

**Option 2: Via Firebase Console**
1. Build APK locally: `flutter build apk --release`
2. Go to: https://console.firebase.google.com/project/angular-amp-421409/appdistribution
3. Click **"Release"** → **"Distribute"**
4. Upload APK file
5. Select "testers" group
6. Add release notes
7. Click **"Distribute"**

---

## 🔧 Troubleshooting

### Issue 1: "Requested entity was not found" (404 Error)

**Cause:** The "testers" group doesn't exist

**Solution:**
1. Go to: https://console.firebase.google.com/project/angular-amp-421409/appdistribution/testers
2. Click **"Add group"**
3. Name: `testers` (exactly, lowercase)
4. Add testers to this group

### Issue 2: Testers Not Receiving Emails

**Possible causes:**
- Tester's email is misspelled
- Tester not in "testers" group
- Email went to spam folder
- Tester needs to accept invitation

**Solution:**
1. Verify tester email is correct
2. Check they're in "testers" group
3. Ask tester to check spam folder
4. Resend invitation from Firebase Console

### Issue 3: GitHub Action Fails to Build

**Common causes:**
- Flutter version mismatch
- Dependencies not installed
- Test failures
- Gradle build errors

**Solution:**
1. Check workflow logs: https://github.com/zicoovic/petfinder_app/actions
2. Read error message
3. Fix locally first: `flutter build apk --release`
4. Push fix

### Issue 4: APK Won't Install on Customer's Phone

**Possible causes:**
- "Install from Unknown Sources" not enabled
- Insufficient storage
- Incompatible Android version
- Previous version not uninstalled

**Solution:**
Send customer these instructions (see [Customer Instructions](#customer-instructions))

### Issue 5: GitHub Secrets Not Working

**Symptoms:**
- Workflow fails at Firebase distribution step
- Error: "Invalid credentials"

**Solution:**
1. Verify secrets exist: https://github.com/zicoovic/petfinder_app/settings/secrets/actions
2. Check secret names are exact:
   - `FIREBASE_APP_ID`
   - `FIREBASE_SERVICE_ACCOUNT`
3. Re-create secrets if needed
4. Re-run workflow

---

## 📱 Customer Instructions

### Email Template for Customers

```
Hi [Customer Name],

You've been invited to test the PetFinder App!

📧 You'll receive an email from Firebase App Distribution with the subject:
"New build available: PetFinder App"

📱 Installation Steps:

1. Open the email on your Android phone
2. Click "Download the latest build"
3. Download the APK file
4. Open your phone Settings → Security (or Privacy)
5. Enable "Install from Unknown Sources" or "Allow from this source"
6. Go to Downloads folder
7. Tap the APK file
8. Tap "Install"
9. Once installed, tap "Open"

⚠️ Important Notes:
- This works on Android phones only (not iPhone)
- You need Android 5.0 (Lollipop) or higher
- Make sure you have at least 100MB free storage
- The app is not on Play Store yet - this is a test version

✨ What to Test:
- Pet adoption feature (adopt/unadopt pets)
- Dark mode toggle (moon/sun icon on home screen)
- Browse pets, search, and filter
- Favorites and adopted screens
- Navigation between screens

🐛 Report Issues:
If you find any bugs, please email me at: [your-email@example.com]

Include:
- What you were doing
- What happened (screenshot if possible)
- Your phone model and Android version

Thanks for testing! 🐱
```

### Step-by-Step Installation Guide (for customers)

**Step 1: Receive Email**
- Check your inbox for "New build available: PetFinder App"
- If not in inbox, check spam folder

**Step 2: Download APK**
- Open email on Android phone
- Click "Download the latest build"
- APK file will download (about 50-100MB)

**Step 3: Enable Unknown Sources**
- Go to Settings → Security (or Apps & notifications)
- Enable "Install unknown apps" or "Unknown sources"
- Allow your browser/email app to install apps

**Step 4: Install APK**
- Go to Downloads folder (or notification)
- Tap the downloaded APK file
- Tap "Install"
- Wait for installation to complete
- Tap "Open" to launch app

**Step 5: Start Testing**
- App opens to onboarding screen
- Browse through and start testing!

---

## 🍎 iOS Setup (Future)

When you're ready to add iOS support:

### Requirements

- [ ] Physical Mac or cloud Mac service
- [ ] Apple Developer Account ($99/year)
- [ ] Xcode installed
- [ ] iOS app registered in Firebase
- [ ] Certificates and provisioning profiles

### Steps

1. **Register iOS App in Firebase:**
   - Go to Firebase Console
   - Add iOS app
   - Bundle ID: `com.example.petfinderApp`
   - Download `GoogleService-Info.plist`
   - Add to `ios/Runner/` folder

2. **Update GitHub Workflow:**
   - Change runner to `macos-latest`
   - Add iOS build commands
   - Add iOS secrets

3. **Distribution Options:**
   - **TestFlight** (recommended for production)
   - **Firebase App Distribution** (easier for testing)

### iOS Workflow Example

```yaml
build-ios:
  runs-on: macos-latest
  steps:
    - uses: actions/checkout@v4
    - uses: subosito/flutter-action@v2
    - run: flutter build ios --release --no-codesign
    # ... additional iOS-specific steps
```

---

## 🔗 Useful Links

### Firebase Console Links

| Resource | URL |
|----------|-----|
| **Project Dashboard** | https://console.firebase.google.com/project/angular-amp-421409 |
| **App Distribution** | https://console.firebase.google.com/project/angular-amp-421409/appdistribution |
| **Testers Management** | https://console.firebase.google.com/project/angular-amp-421409/appdistribution/testers |
| **Releases** | https://console.firebase.google.com/project/angular-amp-421409/appdistribution/releases |
| **Project Settings** | https://console.firebase.google.com/project/angular-amp-421409/settings/general |

### GitHub Links

| Resource | URL |
|----------|-----|
| **Repository** | https://github.com/zicoovic/petfinder_app |
| **Actions** | https://github.com/zicoovic/petfinder_app/actions |
| **Secrets** | https://github.com/zicoovic/petfinder_app/settings/secrets/actions |
| **Workflow File** | https://github.com/zicoovic/petfinder_app/blob/main/.github/workflows/build-and-distribute.yml |

### Documentation

| Topic | URL |
|-------|-----|
| **Firebase App Distribution** | https://firebase.google.com/docs/app-distribution |
| **GitHub Actions** | https://docs.github.com/en/actions |
| **Flutter Build** | https://docs.flutter.dev/deployment/android |

---

## 📊 Workflow Summary

### What Happens When You Push Code

```
┌─────────────────────┐
│  You push to main   │
│   or develop        │
└──────────┬──────────┘
           │
           v
┌─────────────────────┐
│  GitHub Actions     │
│  triggers workflow  │
└──────────┬──────────┘
           │
           v
┌─────────────────────┐
│  Setup environment  │
│  (Java, Flutter)    │
└──────────┬──────────┘
           │
           v
┌─────────────────────┐
│  Install deps       │
│  flutter pub get    │
└──────────┬──────────┘
           │
           v
┌─────────────────────┐
│  Run tests          │
│  flutter test       │
└──────────┬──────────┘
           │
           v
┌─────────────────────┐
│  Build APK          │
│  (5-8 minutes)      │
└──────────┬──────────┘
           │
           v
┌─────────────────────┐
│  Upload to GitHub   │
│  (artifact)         │
└──────────┬──────────┘
           │
           v
┌─────────────────────┐
│  Upload to Firebase │
│  App Distribution   │
└──────────┬──────────┘
           │
           v
┌─────────────────────┐
│  Send emails to     │
│  all testers        │
└─────────────────────┘
```

### Timeline

| Step | Duration |
|------|----------|
| Trigger workflow | Instant |
| Setup environment | 1-2 min |
| Install dependencies | 30 sec |
| Run tests | 30 sec - 2 min |
| Build APK | 5-8 min |
| Upload to Firebase | 1-2 min |
| **Total** | **8-15 min** |
| Email delivery | Instant |

---

## 🎯 Quick Reference Commands

### Check Workflow Status
```bash
# Via GitHub CLI
gh run list --limit 5

# View latest run
gh run view
```

### Build APK Locally
```bash
# Clean build
flutter clean
flutter pub get
flutter build apk --release

# APK location:
# build/app/outputs/flutter-apk/app-release.apk
```

### Firebase CLI Commands
```bash
# Login
firebase login

# List projects
firebase projects:list

# List testers
firebase appdistribution:testers:list --project angular-amp-421409

# Add tester
firebase appdistribution:testers:add email@example.com \
  --project angular-amp-421409 \
  --group testers

# Remove tester
firebase appdistribution:testers:remove email@example.com \
  --project angular-amp-421409

# Distribute APK manually
firebase appdistribution:distribute \
  build/app/outputs/flutter-apk/app-release.apk \
  --app 1:977811551855:android:8897af1ee365c44c037f9a \
  --groups "testers"
```

### Git Commands
```bash
# Push to trigger distribution
git push origin main

# Push empty commit to re-trigger
git commit --allow-empty -m "chore: trigger distribution"
git push origin main

# Check current branch
git branch --show-current

# Switch branches
git checkout main
git checkout develop
```

---

## 📞 Support

### When Things Go Wrong

1. **Check GitHub Actions logs:**
   - https://github.com/zicoovic/petfinder_app/actions
   - Look for red X marks
   - Click to see error details

2. **Check Firebase Console:**
   - See if APK was uploaded
   - Check if testers received it
   - View distribution logs

3. **Test locally first:**
   ```bash
   flutter build apk --release
   ```
   If this fails, fix it before pushing

4. **Common fixes:**
   - Re-run workflow
   - Clear Flutter cache: `flutter clean`
   - Update dependencies: `flutter pub get`
   - Check secrets are set correctly

---

## 🎉 Success Checklist

You know everything is working when:

- [x] Push to main/develop triggers workflow
- [x] Workflow completes successfully (green checkmark)
- [x] APK appears in Firebase Console
- [x] Testers receive email within minutes
- [x] Testers can download and install APK
- [x] App runs on tester's device
- [x] You can see downloads/feedback in Firebase

---

## 📝 Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2025-01-29 | Initial Firebase App Distribution setup |

---

**Need Help?** Check the [Troubleshooting](#troubleshooting) section or contact your Firebase admin.

---

**Built with ❤️ for PetFinder App**
