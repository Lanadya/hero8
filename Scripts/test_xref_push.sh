#!/bin/bash

# test_xref_push.sh - Testet das Pushen ins xcode-reference Repository

echo "=== Test des xcode-reference Push-Prozesses ==="

HERO8_DIR="/Users/ninaklee/Projects/hero8"
XCODE_REF_DIR="/Users/ninaklee/Projects/xcode-reference"
TEST_FILE="$XCODE_REF_DIR/versions/16.3/docs/test.md"

# 1. Prüfe Git-Status
echo "1. Git-Status prüfen:"
cd "$XCODE_REF_DIR"
git status

# 2. Frage ob fortfahren
echo ""
read -p "Möchten Sie mit dem Test-Push fortfahren? (j/n): " choice
if [[ ! "$choice" =~ ^[Jj]$ ]]; then
    echo "Test abgebrochen."
    exit 0
fi

# 3. Sichere den Test-Push
echo ""
echo "2. Führe sicheren Test-Push durch:"
"$HERO8_DIR/Scripts/secure_auto_push.sh" push "$XCODE_REF_DIR" "Test-Push zur Überprüfung des Systems"

# 4. Prüfe Ergebnis
echo ""
echo "3. Push-Ergebnis:"
git log -1

# 5. Aufräumen
echo ""
read -p "Test-Datei wieder löschen? (j/n): " cleanup
if [[ "$cleanup" =~ ^[Jj]$ ]]; then
    rm "$TEST_FILE"
    git add "$TEST_FILE"
    git commit -m "Test-Dokument entfernt"
    git push
    echo "Test-Datei wurde entfernt und Änderung gepusht."
fi

echo ""
echo "=== Test abgeschlossen ==="
