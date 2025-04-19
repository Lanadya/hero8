#!/bin/bash

# Skript zum Aktualisieren des xcode-reference Repositories und Rückkehr zu hero8
# Erstellt am: 2025-04-19

# Ursprüngliches Verzeichnis merken (sollte hero8 sein)
ORIGINAL_DIR=$(pwd)

# Zu xcode-reference wechseln
echo "📂 Wechsle zu xcode-reference Repository..."
cd /Users/ninaklee/Projects/xcode-reference

# Status prüfen
echo "🔍 Prüfe Status des xcode-reference Repositories..."
git status

# Secure commit script ausführen
echo "🚀 Führe Commit und Push aus..."
./secure_commit_new_docs.sh

# Zurück zum ursprünglichen Verzeichnis
echo "🔙 Kehre zu hero8 zurück..."
cd "$ORIGINAL_DIR"
echo "📍 Aktuelles Verzeichnis: $(pwd)"
echo "✅ xcode-reference Update abgeschlossen! Sie befinden sich wieder im hero8-Projekt."
