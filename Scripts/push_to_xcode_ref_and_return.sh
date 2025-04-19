#!/bin/bash

# push_to_xcode_ref_and_return.sh - Wechselt zu xcode-reference, pusht und kehrt zurück
# Erstellt am: 2025-04-19

# Aktuelle Position speichern
CURRENT_DIR=$(pwd)
echo "🔍 Aktuelle Position: $CURRENT_DIR"

# Zu xcode-reference wechseln
echo "🚀 Wechsle zu xcode-reference..."
cd /Users/ninaklee/Projects/xcode-reference

# Status prüfen
echo "📊 Git Status in xcode-reference:"
git status

# Nach Bestätigung fragen
read -p "Möchten Sie die Änderungen committen und pushen? (j/n): " confirm

if [[ "$confirm" =~ ^[Jj]$ ]]; then
    # Commit-Nachricht eingeben
    read -p "Geben Sie die Commit-Nachricht ein: " commit_msg
    
    # Alle Änderungen hinzufügen
    git add .
    
    # Commit
    git commit -m "$commit_msg"
    
    # Push
    echo "🚀 Push zu GitHub..."
    git push origin main
    
    echo "✅ Push erfolgreich abgeschlossen!"
else
    echo "❌ Push abgebrochen."
fi

# Zurück zum ursprünglichen Verzeichnis
echo "↩️ Kehre zurück zu: $CURRENT_DIR"
cd "$CURRENT_DIR"

echo "✅ Wieder zurück in: $(pwd)"
