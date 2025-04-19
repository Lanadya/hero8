#!/bin/bash

# Skript zum Aktualisieren des xcode-reference Repositories von hero8 aus
# Erstellt am: 2025-04-19

# Aktuelles Verzeichnis speichern (sollte hero8 sein)
ORIGINAL_DIR=$(pwd)

echo "📂 Starte Update des xcode-reference Repositories..."
echo "📍 Aktuelles Verzeichnis: $ORIGINAL_DIR"

# Zu xcode-reference wechseln
echo "🔄 Wechsle zu xcode-reference..."
cd /Users/ninaklee/Projects/xcode-reference

# Status anzeigen
echo "🔍 Aktueller Status des xcode-reference Repositories:"
git status

# Wenn das Strukturupdate-Skript existiert, ausführen
if [ -f "update_structure_and_return.sh" ]; then
    echo "🚀 Führe Strukturupdate aus..."
    ./update_structure_and_return.sh
else
    echo "❌ Strukturupdate-Skript nicht gefunden."
    echo "🔄 Versuche direkten Commit der neuen Struktur..."
    
    # Fallback: Direkte Git-Operationen
    echo "📦 Füge neue Struktur hinzu..."
    git add versions/16.3/docs/testing/
    git add versions/16.3/docs/ci-cd/
    git add versions/16.3/docs/asset-management/
    git add versions/16.3/docs/multi-platform/
    git add versions/16.3/docs/community/
    git add versions/16.3/docs/README_UPDATES.md
    git add TEMPLATE.md
    git add STRUCTURE_PROPOSAL.md

    # Commit durchführen
    echo "💾 Committe Änderungen..."
    COMMIT_MSG="Erweiterte Dokumentationsstruktur für zukünftige Beiträge

Neue Verzeichnisse und Platzhalter für:
- Testing und Automation
- CI/CD Integration
- Advanced Asset Management
- Multi-Platform Development
- Community Contribution Guidelines
- Projekt Roadmap

Zusätzlich:
- Dokumentations-Template für neue Beiträge
- Strukturvorschlag für Repository-Erweiterung
- README-Updates für geplante Inhalte

Diese Struktur ermöglicht es der Community, gezielt zu bestimmten Themen beizutragen."

    git commit -m "$COMMIT_MSG"
    
    # Push durchführen
    echo "🚀 Push nach GitHub..."
    git push origin main
fi

# Zurück zum ursprünglichen Verzeichnis
echo "🔙 Kehre zum hero8-Projekt zurück..."
cd "$ORIGINAL_DIR"
echo "📍 Aktuelles Verzeichnis: $(pwd)"
echo "✅ xcode-reference Update abgeschlossen! Sie sind zurück im hero8-Projekt."
