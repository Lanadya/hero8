#!/bin/bash

# check_xref_status.sh - Prüft den Git-Status im xcode-reference Repository

XCODE_REF_DIR="/Users/ninaklee/Projects/xcode-reference"

echo "=== xcode-reference Git Status ==="
cd "$XCODE_REF_DIR"
git status

echo ""
echo "=== Untracked/Modified Files ==="
git status --porcelain

echo ""
echo "=== Remote URL ==="
git remote -v
