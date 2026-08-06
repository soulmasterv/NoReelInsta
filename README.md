# NoReelInsta

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Theos](https://img.shields.io/badge/Built%20with-Theos-blue)](https://theos.dev)
[![Instagram 440.0.0](https://img.shields.io/badge/Instagram-440.0.0-purple)](https://apps.apple.com/us/app/instagram/id389801252)

**Ultra-minimal Instagram tweak for iOS** that only:
1. ✅ **Removes the Reels tab** from the navigation bar
2. ✅ **Disables scrolling when clicking on a reel** (prevents doomscrolling)

---

## Why NoReelInsta?
- **Ultra-minimalist**: Only **4 hooks** (vs 100+ in SCInsta)
- **Stable**: Less code = lower risk of conflicts with Instagram updates
- **Easy to maintain**: Only 2 features to check if Instagram changes
- **No settings**: Everything is enabled by default

---

## Requirements
1. **Theos**: iOS tweak development toolkit ([installation guide](https://theos.dev/docs/installation))
2. **Decrypted Instagram IPA**: Place in `NoReelInsta/packages/com.burbn.instagram.ipa`
3. **Tools**:
   - `cyan`: `pip install pyzule-rw` (for tweak injection)
   - `ipapatch`: Download from [ipapatch releases](https://github.com/asdfzxcvbn/ipapatch/releases) (for sideloading patch)
4. **Mac**: macOS with Xcode Command Line Tools (`xcode-select --install`)

---

## Installation

### 1️⃣ Place the Instagram IPA
Place the decrypted Instagram `.ipa` file here:
```bash
NoReelInsta/packages/com.burbn.instagram.ipa
```

### 2️⃣ Build the tweak
```bash
cd NoReelInsta
chmod +x build.sh
./build.sh sideload
```

### 3️⃣ Install on iPhone
- The final IPA will be generated at: `NoReelInsta/packages/NoReelInsta-sideloaded.ipa`
- Install it using **AltStore** or **Sideloadly**

---

## Updating Instagram

If Instagram updates via the App Store:
1. **Delete** the old modified app from your iPhone
2. **Download** the new decrypted Instagram `.ipa`
3. **Replace** `com.burbn.instagram.ipa` in `NoReelInsta/packages/`
4. **Recompile** with `cd NoReelInsta && ./build.sh sideload`
5. **Reinstall** the generated IPA (`NoReelInsta/packages/NoReelInsta-sideloaded.ipa`)

---

## Project Structure
```
NoReelInsta/
├── Makefile              # Theos configuration
├── Tweak.x               # Main code (4 hooks)
├── Tweak.h               # Declarations
├── Utils.h/.m            # Utility functions (ivar access)
├── InstagramHeaders.h    # Instagram class declarations
├── build.sh              # Build script
├── control               # Package metadata
├── LICENSE               # GPLv3 License
├── CHANGELOG.md          # Version history
├── VERSION               # Current version
├── README.md             # Documentation
└── packages/             # IPA files directory
    ├── com.burbn.instagram.ipa      # Original IPA (place here)
    └── NoReelInsta-sideloaded.ipa   # Final IPA (generated)
```

---

## Customization

To **disable** a feature, modify these lines in `Tweak.x`:
```c
#define ALWAYS_HIDE_REELS_TAB NO   // Disable Reels tab removal
#define ALWAYS_DISABLE_SCROLLING NO // Disable scroll blocking
```

---

## Credits
- [SoCuul](https://github.com/SoCuul) for [SCInsta](https://github.com/SoCuul/SCInsta), which this project is based on.
