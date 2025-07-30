#!/bin/bash
# Codesign script for macOS distribution
# Usage: ./codesign.sh "Developer ID: Your Name (TEAM_ID)"

if [ -z "$1" ]; then
    echo "Usage: $0 \"Developer ID: Your Name (TEAM_ID)\""
    exit 1
fi

IDENTITY="$1"

echo "Codesigning xray binary..."
codesign --force --verify --verbose --sign "$IDENTITY" xray

echo "Verifying signature..."
codesign --verify --verbose xray

echo "Codesigning complete!"
