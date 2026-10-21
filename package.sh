#!/bin/bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_NAME="Dopamine"
VERSION="1.2.1"
DIST_DIR="$DIR/dist"
BUNDLE_PATH="$DIR/build/$APP_NAME.app"

echo "=== Packaging $APP_NAME v$VERSION for Distribution ==="

# 1. Build app
"$DIR/build.sh"

rm -rf "$DIST_DIR"
mkdir -p "$DIST_DIR"

# 2. Build DMG
echo "Creating $APP_NAME.dmg..."
TMP_DMG=$(mktemp -d /tmp/dopamine_dmg.XXXXXX)
cp -R "$BUNDLE_PATH" "$TMP_DMG/"
ln -s /Applications "$TMP_DMG/Applications"
rm -f "$DIST_DIR/$APP_NAME.dmg"
hdiutil create -volname "$APP_NAME" -srcfolder "$TMP_DMG" -ov -format UDZO "$DIST_DIR/$APP_NAME.dmg"
rm -rf "$TMP_DMG"

# Codesign DMG if Developer ID is available
SIGN_IDENTITY=$(security find-identity -v -p codesigning | grep "Developer ID Application" | head -n 1 | awk -F '"' '{print $2}' || true)
if [ -n "$SIGN_IDENTITY" ]; then
    echo "Signing DMG with Developer ID: $SIGN_IDENTITY"
    codesign --force --timestamp --sign "$SIGN_IDENTITY" "$DIST_DIR/$APP_NAME.dmg"
fi

# Apple Notarization
AUTH_KEY="$HOME/.private_keys/AuthKey_X5SJQ3X247.p8"
KEY_ID="X5SJQ3X247"
ISSUER_ID="0635b165-8df6-4c3e-a41b-db9da323cbf1"

if [ -f "$AUTH_KEY" ] && [ -n "$SIGN_IDENTITY" ]; then
    echo "Submitting $APP_NAME.dmg to Apple Notary Service..."
    xcrun notarytool submit "$DIST_DIR/$APP_NAME.dmg" \
        --key "$AUTH_KEY" \
        --key-id "$KEY_ID" \
        --issuer "$ISSUER_ID" \
        --wait

    echo "Stapling notarization ticket to $APP_NAME.dmg..."
    xcrun stapler staple "$DIST_DIR/$APP_NAME.dmg"

    echo "Stapling notarization ticket to $BUNDLE_PATH..."
    xcrun stapler staple "$BUNDLE_PATH" || true
fi

# 3. Build ZIP for silent in-place auto-update
echo "Creating $APP_NAME.zip for silent auto-updater..."
rm -f "$DIST_DIR/$APP_NAME.zip"
ditto -c -k --keepParent "$BUNDLE_PATH" "$DIST_DIR/$APP_NAME.zip"

# 4. Build PKG
echo "Creating $APP_NAME-Installer.pkg..."
rm -f "$DIST_DIR/$APP_NAME-Installer.pkg"
export COPYFILE_DISABLE=1
pkgbuild --root "$DIR/build" \
         --install-location /Applications \
         --identifier com.alexey.Dopamine \
         --version "$VERSION" \
         "$DIST_DIR/$APP_NAME-Installer.pkg"

# 5. Generate SHA-256 Checksums
echo "Generating SHA-256 Checksums..."
DMG_SHA256=$(shasum -a 256 "$DIST_DIR/$APP_NAME.dmg" | awk '{print $1}')
ZIP_SHA256=$(shasum -a 256 "$DIST_DIR/$APP_NAME.zip" | awk '{print $1}')
PKG_SHA256=$(shasum -a 256 "$DIST_DIR/$APP_NAME-Installer.pkg" | awk '{print $1}')

echo "$DMG_SHA256  $APP_NAME.dmg" > "$DIST_DIR/checksums.txt"
echo "$ZIP_SHA256  $APP_NAME.zip" >> "$DIST_DIR/checksums.txt"
echo "$PKG_SHA256  $APP_NAME-Installer.pkg" >> "$DIST_DIR/checksums.txt"

# 6. Generate Homebrew Cask Formula (dopamine.rb)
cat <<EOF > "$DIST_DIR/dopamine.rb"
cask "dopamine" do
  version "$VERSION"
  sha256 "$DMG_SHA256"

  url "https://dopamine.33rd.pro/Dopamine.dmg"
  name "Dopamine"
  desc "Keep-awake power utility with closed-lid display backlight cutoff for Apple Silicon"
  homepage "https://dopamine.33rd.pro"

  auto_updates true
  depends_on macos: ">= :monterey"
  depends_on arch: :arm64

  app "Dopamine.app"

  zap trash: [
    "~/Library/Application Support/Dopamine",
    "~/Library/Caches/com.alexey.Dopamine",
    "~/Library/HTTPStorages/com.alexey.Dopamine",
    "~/Library/Preferences/com.alexey.Dopamine.plist",
  ]
end
EOF

# Copy formula to root and web
cp "$DIST_DIR/dopamine.rb" "$DIR/dopamine.rb"
if [ -d "$DIR/web" ]; then
    cp "$DIST_DIR/dopamine.rb" "$DIR/web/dopamine.rb"
fi

# 7. Generate OTA Update Manifest (latest.json)
cat <<EOF > "$DIST_DIR/latest.json"
{
  "version": "$VERSION",
  "build": 13,
  "releaseDate": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "downloadUrl": "https://dopamine.33rd.pro/Dopamine.dmg",
  "zipUrl": "https://dopamine.33rd.pro/Dopamine.zip",
  "githubDownloadUrl": "https://github.com/UniversalSDK/Dopamine/releases/download/v$VERSION/Dopamine.dmg",
  "githubZipUrl": "https://github.com/UniversalSDK/Dopamine/releases/download/v$VERSION/Dopamine.zip",
  "sha256": "$DMG_SHA256",
  "zipSha256": "$ZIP_SHA256",
  "releaseNotes": "Dopamine v$VERSION: Fixes display flickering under closed lid with native DPMS sleep; adds seamless silent in-place background auto-updates.",
  "minOS": "12.0"
}
EOF

# Copy latest.json to root, releases folder (for github raw), and web
mkdir -p "$DIR/releases"
cp "$DIST_DIR/latest.json" "$DIR/releases/latest.json"
cp "$DIST_DIR/latest.json" "$DIR/latest.json"
if [ -d "$DIR/web" ]; then
    cp "$DIST_DIR/latest.json" "$DIR/web/latest.json"
fi

# 8. Copy release artifacts and landing page to Desktop for convenient access
DESKTOP_DIR="/Users/alexey/Desktop/Dopamine"
rm -rf "$DESKTOP_DIR"
mkdir -p "$DESKTOP_DIR"
cp -R "$BUNDLE_PATH" "$DESKTOP_DIR/"
cp "$DIST_DIR/$APP_NAME.dmg" "$DESKTOP_DIR/"
cp "$DIST_DIR/$APP_NAME.zip" "$DESKTOP_DIR/"
cp "$DIST_DIR/$APP_NAME-Installer.pkg" "$DESKTOP_DIR/"
cp "$DIST_DIR/dopamine.rb" "$DESKTOP_DIR/"
cp "$DIST_DIR/latest.json" "$DESKTOP_DIR/"
cp "$DIST_DIR/checksums.txt" "$DESKTOP_DIR/"

# Copy landing page to Desktop/Dopamine/landing
if [ -d "$DIR/web" ]; then
    cp -R "$DIR/web" "$DESKTOP_DIR/landing"
fi

echo "=== Distribution packages and Landing created in $DIST_DIR and $DESKTOP_DIR ==="
ls -lh "$DIST_DIR"
