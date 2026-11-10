#!/usr/bin/env bash
set -euo pipefail

APP_NAME="CherryPicker"
VERSION="${1:-1.0.0}"
ARCH="${2:-arm64}"
CUSTOM_DMG_NAME="${3:-}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

cd "${PROJECT_ROOT}"

echo "=== [1/5] Compiling Release binary (${ARCH}) ==="
swift build -c release --arch "${ARCH}"

BIN_PATH=".build/${ARCH}-apple-macosx/release/${APP_NAME}"
if [ ! -f "${BIN_PATH}" ]; then
    echo "Error: Compiled binary not found at ${BIN_PATH}"
    exit 1
fi

echo "=== [2/5] Assembling ${APP_NAME}.app bundle structure ==="
APP_BUNDLE="${APP_NAME}.app"
rm -rf "${APP_BUNDLE}"
mkdir -p "${APP_BUNDLE}/Contents/MacOS"
mkdir -p "${APP_BUNDLE}/Contents/Resources"

cp "${BIN_PATH}" "${APP_BUNDLE}/Contents/MacOS/${APP_NAME}"
chmod +x "${APP_BUNDLE}/Contents/MacOS/${APP_NAME}"

# Wstrzyknięcie Info.plist z podmianą wersji
if [ -f "Info.plist" ]; then
    sed -E "s/<string>1.0.0<\/string>/<string>${VERSION}<\/string>/g" Info.plist > "${APP_BUNDLE}/Contents/Info.plist"
else
    echo "Info.plist file missing in project root!"
    exit 1
fi

# Kompilacja katalogu zasobów (Asset Catalog) dla natywnego wsparcia ikon macOS
if command -v xcrun >/dev/null 2>&1 && xcrun --find actool >/dev/null 2>&1 && [ -d "Assets.xcassets" ]; then
    echo "Compiling Assets.xcassets using actool..."
    xcrun actool Assets.xcassets \
        --compile "${APP_BUNDLE}/Contents/Resources" \
        --platform macosx \
        --app-icon AppIcon \
        --minimum-deployment-target 13.0 \
        --output-partial-info-plist /tmp/actool_partial.plist \
        --output-format human-readable-text >/dev/null 2>&1 || true
fi

# Fallback: jeśli Assets.car lub AppIcon.icns nie zostały wygenerowane przez actool, skopiuj istniejące
if [ -f "Assets.car" ] && [ ! -f "${APP_BUNDLE}/Contents/Resources/Assets.car" ]; then
    cp Assets.car "${APP_BUNDLE}/Contents/Resources/"
fi

if [ -f "AppIcon.icns" ] && [ ! -f "${APP_BUNDLE}/Contents/Resources/AppIcon.icns" ]; then
    cp AppIcon.icns "${APP_BUNDLE}/Contents/Resources/"
fi

echo "=== [3/5] Code signing application ==="
# Sprawdzenie dostępnych certyfikatów w Pęku kluczy (np. Apple Development)
SIGN_IDENTITY=$(security find-identity -p codesigning -v 2>/dev/null | grep -E "Apple Development" | head -n 1 | awk -F '"' '{print $2}' || true)
if [ -z "${SIGN_IDENTITY}" ]; then
    SIGN_IDENTITY=$(security find-identity -p codesigning -v 2>/dev/null | grep -E '"[^"]+"' | head -n 1 | awk -F '"' '{print $2}' || true)
fi

if [ -n "${SIGN_IDENTITY}" ]; then
    echo "Using signing identity: ${SIGN_IDENTITY}"
    codesign --force --deep -s "${SIGN_IDENTITY}" "${APP_BUNDLE}"
else
    echo "No Developer certificate found in Keychain. Signing with designated requirement..."
    codesign --force --deep -s - -r='designated => identifier "com.wyroczen.CherryPicker"' "${APP_BUNDLE}"
fi

echo "=== [4/5] Staging DMG contents ==="
DMG_STAGING="dmg_staging"
rm -rf "${DMG_STAGING}"
mkdir -p "${DMG_STAGING}"

cp -R "${APP_BUNDLE}" "${DMG_STAGING}/"
# Utworzenie symlinka do katalogu /Applications
ln -s /Applications "${DMG_STAGING}/Applications"

echo "=== [5/5] Creating DMG disk image ==="
if [ -n "${CUSTOM_DMG_NAME}" ]; then
    DMG_NAME="${CUSTOM_DMG_NAME}"
else
    DMG_NAME="${APP_NAME}-${VERSION}-${ARCH}.dmg"
fi

rm -f "${DMG_NAME}"
hdiutil create -volname "${APP_NAME}" \
               -srcfolder "${DMG_STAGING}" \
               -ov -format UDZO \
               "${DMG_NAME}"

rm -rf "${DMG_STAGING}"
echo "=== Success! Generated: ${DMG_NAME} ==="
