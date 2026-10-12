#!/bin/bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_NAME="Dopamine"
VERSION="1.2.0"
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

# 3. Build PKG
echo "Creating $APP_NAME-Installer.pkg..."
rm -f "$DIST_DIR/$APP_NAME-Installer.pkg"
export COPYFILE_DISABLE=1
pkgbuild --root "$DIR/build" \
         --install-location /Applications \
         --identifier com.alexey.Dopamine \
         --version "$VERSION" \
         "$DIST_DIR/$APP_NAME-Installer.pkg"

# 4. Generate SHA-256 Checksums
echo "Generating SHA-256 Checksums..."
DMG_SHA256=$(shasum -a 256 "$DIST_DIR/$APP_NAME.dmg" | awk '{print $1}')
echo "$DMG_SHA256  $APP_NAME.dmg" > "$DIST_DIR/checksums.txt"
shasum -a 256 "$DIST_DIR/$APP_NAME-Installer.pkg" >> "$DIST_DIR/checksums.txt"

# 5. Generate Homebrew Cask Formula (dopamine.rb)
cat <<EOF > "$DIST_DIR/dopamine.rb"
cask "dopamine" do
  version "$VERSION"
  sha256 "$DMG_SHA256"

  url "https://github.com/alexey/Dopamine/releases/download/v#{version}/Dopamine.dmg"
  name "Dopamine"
  desc "Keep-awake power utility with closed-lid display backlight cutoff for Apple Silicon"
  homepage "https://github.com/alexey/Dopamine"

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

# 6. Generate OTA Update Manifest (latest.json)
cat <<EOF > "$DIST_DIR/latest.json"
{
  "version": "$VERSION",
  "build": 12,
  "releaseDate": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "downloadUrl": "https://github.com/alexey/Dopamine/releases/download/v$VERSION/Dopamine.dmg",
  "sha256": "$DMG_SHA256",
  "releaseNotes": "Dopamine v$VERSION (Apple Silicon Edition): Pure native Swift keep-awake utility with dual-mode hardware backlight cutoff, 11 languages, battery safeguards, and zero-nit clamshell mode.",
  "minOS": "12.0"
}
EOF

# 7. Copy release artifacts and landing page to Desktop for convenient access
DESKTOP_DIR="/Users/alexey/Desktop/Dopamine"
rm -rf "$DESKTOP_DIR"
mkdir -p "$DESKTOP_DIR"
cp -R "$BUNDLE_PATH" "$DESKTOP_DIR/"
cp "$DIST_DIR/$APP_NAME.dmg" "$DESKTOP_DIR/"
cp "$DIST_DIR/$APP_NAME-Installer.pkg" "$DESKTOP_DIR/"
cp "$DIST_DIR/dopamine.rb" "$DESKTOP_DIR/"
cp "$DIST_DIR/latest.json" "$DESKTOP_DIR/"
cp "$DIST_DIR/checksums.txt" "$DESKTOP_DIR/"

# Copy landing page to Desktop/Dopamine/landing
if [ -d "$DIR/web" ]; then
    cp -R "$DIR/web" "$DESKTOP_DIR/landing"
fi

# Clean up previous folders
rm -rf "/Users/alexey/Desktop/AmphiGuard" "/Users/alexey/Desktop/LidGuard"

echo "=== Distribution packages and Landing created in $DIST_DIR and $DESKTOP_DIR ==="
ls -lh "$DESKTOP_DIR"
