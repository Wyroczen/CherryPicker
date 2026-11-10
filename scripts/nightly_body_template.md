### 🍒 CherryPicker Nightly Build (__SHORT_SHA__)
Automated developer build built from the latest commit on `main`.

* **Latest Commit:** __COMMIT_MSG__ (`__SHORT_SHA__`)
* **Architecture:** Apple Silicon (`arm64`)

#### How to install:
1. Download the `__DMG_NAME__` installer below.
2. Open the DMG image and drag **CherryPicker** to your **Applications** folder.
3. On first launch, macOS Gatekeeper may show an untrusted developer prompt (as this is an open-source build without an Apple Developer certificate):
   - Navigate to **System Settings -> Privacy & Security**, scroll down to the Security section, and click **Open Anyway**.
   - Or alternatively, run the following command in Terminal:
     ```bash
     xattr -cr /Applications/CherryPicker.app
     ```
