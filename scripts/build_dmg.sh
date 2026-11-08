#!/usr/bin/env bash
set -euo pipefail

APP_NAME="CherryPicker"
VERSION="${1:-1.0.0}"
ARCH="${2:-arm64}"
CUSTOM_DMG_NAME="${3:-}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

cd "${PROJECT_ROOT}"

echo "=== [1/5] Kompilacja binarki Release (${ARCH}) ==="
swift build -c release --arch "${ARCH}"

BIN_PATH=".build/${ARCH}-apple-macosx/release/${APP_NAME}"
if [ ! -f "${BIN_PATH}" ]; then
    echo "Błąd: Nie znaleziono skompilowanej binarki w ${BIN_PATH}"
    exit 1
fi

echo "=== [2/5] Składanie struktury ${APP_NAME}.app ==="
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
    echo "Brak pliku Info.plist w katalogu głównym!"
    exit 1
fi

# Jeśli istnieje ikona AppIcon.icns, skopiuj ją
if [ -f "AppIcon.icns" ]; then
    cp AppIcon.icns "${APP_BUNDLE}/Contents/Resources/"
fi

echo "=== [3/5] Podpisywanie ad-hoc (wymagane na Apple Silicon) ==="
codesign --force --deep -s - "${APP_BUNDLE}"

echo "=== [4/5] Przygotowanie zawartości DMG ==="
DMG_STAGING="dmg_staging"
rm -rf "${DMG_STAGING}"
mkdir -p "${DMG_STAGING}"

cp -R "${APP_BUNDLE}" "${DMG_STAGING}/"
# Utworzenie symlinka do katalogu /Applications
ln -s /Applications "${DMG_STAGING}/Applications"

echo "=== [5/5] Tworzenie obrazu DMG ==="
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
echo "=== Sukces! Utworzono plik: ${DMG_NAME} ==="
