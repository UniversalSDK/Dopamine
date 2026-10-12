#!/bin/bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_NAME="Dopamine"
BUNDLE_DIR="$DIR/build/$APP_NAME.app"
CONTENTS_DIR="$BUNDLE_DIR/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
RESOURCES_DIR="$CONTENTS_DIR/Resources"

echo "=== Building $APP_NAME for Apple Silicon ==="

rm -rf "$DIR/build"
mkdir -p "$MACOS_DIR"
mkdir -p "$RESOURCES_DIR"

# 1. Compile Swift sources
echo "Compiling Swift sources with optimizations..."
swiftc -O \
    -F /System/Library/PrivateFrameworks \
    -framework DisplayServices \
    -framework login \
    -framework IOKit \
    -framework CoreGraphics \
    -framework AppKit \
    -framework Foundation \
    -framework Security \
    "$DIR"/src/*.swift \
    -o "$MACOS_DIR/$APP_NAME"

# 2. Copy Info.plist
cp "$DIR/Resources/Info.plist" "$CONTENTS_DIR/Info.plist"

# 3. Copy Application Icon
if [ -f "$DIR/Resources/AppIcon.icns" ]; then
    cp "$DIR/Resources/AppIcon.icns" "$RESOURCES_DIR/AppIcon.icns"
fi

# 4. Check for Developer ID signing identity
SIGN_IDENTITY=$(security find-identity -v -p codesigning | grep "Developer ID Application" | head -n 1 | awk -F '"' '{print $2}' || true)

if [ -n "$SIGN_IDENTITY" ]; then
    echo "Found Developer ID Certificate: $SIGN_IDENTITY"
    echo "Signing with Developer ID, Hardened Runtime and Secure Timestamp..."
    codesign --force --options runtime --timestamp \
        --entitlements "$DIR/Resources/entitlements.plist" \
        --sign "$SIGN_IDENTITY" \
        "$BUNDLE_DIR"
else
    echo "No 'Developer ID Application' certificate found in Keychain."
    echo "Signing with Hardened Runtime (ad-hoc / local developer)..."
    codesign --force --options runtime \
        --entitlements "$DIR/Resources/entitlements.plist" \
        --sign - \
        "$BUNDLE_DIR"
fi

echo "=== Build Successful: $BUNDLE_DIR ==="
