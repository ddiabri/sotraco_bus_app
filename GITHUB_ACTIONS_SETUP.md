# GitHub Actions Setup for API 35 Build

This guide will help you build your app with API 35 using GitHub Actions (Linux), avoiding the Windows SDK corruption bug.

## Step 1: Encode Your Keystore

Run this command in PowerShell:

```powershell
cd C:\Users\ddiab\sotraco_bus_app\android
[Convert]::ToBase64String([IO.File]::ReadAllBytes("upload-keystore.jks")) | Set-Clipboard
```

This copies the base64-encoded keystore to your clipboard.

## Step 2: Add GitHub Secrets

1. Go to https://github.com/ddiabri/sotraco_bus_app/settings/secrets/actions

2. Click **"New repository secret"** and add these 4 secrets:

### Secret 1: KEYSTORE_BASE64
- Name: `KEYSTORE_BASE64`
- Value: Paste from clipboard (Ctrl+V)

### Secret 2: KEYSTORE_PASSWORD
- Name: `KEYSTORE_PASSWORD`
- Value: `sotraco2024`

### Secret 3: KEY_PASSWORD
- Name: `KEY_PASSWORD`
- Value: `sotraco2024`

### Secret 4: KEY_ALIAS
- Name: `KEY_ALIAS`
- Value: `upload`

## Step 3: Push Code to Trigger Build

The workflow will automatically run when you push to master.

Already done by Claude! Just wait for the build to complete.

## Step 4: Download the Built App Bundle

1. Go to https://github.com/ddiabri/sotraco_bus_app/actions

2. Click on the latest workflow run

3. Scroll down to **"Artifacts"**

4. Download **"app-release"** (this is your AAB file with API 35)

5. Upload to Google Play Console

---

## Build Status

The workflow builds with:
- ✓ API Level 35 (targetSdk and compileSdk)
- ✓ Signed with your keystore
- ✓ Version code 2
- ✓ On Ubuntu (no Windows SDK bug)

Build time: ~3-5 minutes
