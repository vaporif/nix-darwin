#!/bin/bash

# LibreWolf DMG installer script for macOS ARM64
# This script downloads and installs the latest LibreWolf from GitLab

set -e

# Configuration
PROJECT_ID="44042130"
GITLAB_API="https://gitlab.com/api/v4"
TEMP_DIR="/tmp/librewolf-install"
APP_NAME="LibreWolf.app"
INSTALL_PATH="/Applications"

# Function to get latest version
get_latest_version() {
    curl -s "${GITLAB_API}/projects/${PROJECT_ID}/releases" | \
        grep -o '"tag_name":"[^"]*"' | \
        head -1 | \
        sed 's/"tag_name":"\([^"]*\)"/\1/'
}

# Function to get installed version
get_installed_version() {
    if [ -d "${INSTALL_PATH}/${APP_NAME}" ]; then
        /usr/bin/defaults read "${INSTALL_PATH}/${APP_NAME}/Contents/Info.plist" CFBundleShortVersionString 2>/dev/null || echo ""
    else
        echo ""
    fi
}

# Function to download and install
install_librewolf() {
    # Check if LibreWolf is running
    if pgrep -i "librewolf" > /dev/null; then
        echo "LibreWolf is currently running. Skipping update."
        hdiutil detach "$MOUNT_POINT" -quiet 2>/dev/null || true
        rm -rf "$TEMP_DIR"
        exit 0
    fi
    echo "Fetching latest LibreWolf version..."
    VERSION=$(get_latest_version)

    if [ -z "$VERSION" ]; then
        echo "Error: Could not determine latest version"
        exit 1
    fi

    echo "Latest version: $VERSION"

    # Check installed version
    INSTALLED_VERSION=$(get_installed_version)
    if [ -n "$INSTALLED_VERSION" ]; then
        echo "Installed version: $INSTALLED_VERSION"
        if [ "$INSTALLED_VERSION" = "$VERSION" ]; then
            echo "LibreWolf is already up to date. Skipping installation."
            exit 0
        fi
    else
        echo "LibreWolf not currently installed."
    fi

    # Construct download URL for ARM64
    DMG_URL="${GITLAB_API}/projects/${PROJECT_ID}/packages/generic/librewolf/${VERSION}/librewolf-${VERSION}-macos-arm64-package.dmg"

    echo "Downloading LibreWolf ${VERSION} for ARM64..."

    # Create temp directory
    mkdir -p "$TEMP_DIR"

    # Download DMG
    curl -L -o "${TEMP_DIR}/librewolf.dmg" "$DMG_URL"

    # Mount DMG
    echo "Mounting DMG..."
    hdiutil attach "${TEMP_DIR}/librewolf.dmg" -nobrowse -quiet

    # Find mount point
    MOUNT_POINT=$(hdiutil info | grep "LibreWolf" | awk '{print $1}' | head -1)
    VOLUME_PATH="/Volumes/LibreWolf"


    # Remove old installation if exists
    if [ -d "${INSTALL_PATH}/${APP_NAME}" ]; then
        echo "Removing old LibreWolf installation..."
        rm -rf "${INSTALL_PATH}/${APP_NAME}"
    fi

    # Copy app to Applications
    echo "Installing LibreWolf to ${INSTALL_PATH}..."
    cp -R "${VOLUME_PATH}/${APP_NAME}" "${INSTALL_PATH}/"

    # Unmount DMG
    echo "Cleaning up..."
    hdiutil detach "$MOUNT_POINT" -quiet

    # Clean up temp files
    rm -rf "$TEMP_DIR"

    # Remove quarantine attribute (since it's unsigned)
    xattr -r -d com.apple.quarantine "${INSTALL_PATH}/${APP_NAME}" 2>/dev/null || true

    echo "LibreWolf ${VERSION} installed successfully!"
}

# Check if running on ARM64
if [[ $(uname -m) != "arm64" ]]; then
    echo "Warning: This script is intended for ARM64 Macs"
fi

# Main execution
install_librewolf
