#!/bin/bash

# safe_session_backup.sh - Sichere Sitzungs-Sicherung für hero8
# Erstellt am: 2025-04-19
# Sichert nur dann, wenn das Skript explizit aufgerufen wird

PROJECT_ROOT="/Users/ninaklee/Projects/hero8"
LOG_FILE="$PROJECT_ROOT/backup.log"

# Funktion zum Prüfen des aktuellen Projekts
check_current_project() {
    local current_dir=$(pwd)
    if [[ "$current_dir" != "$PROJECT_ROOT"* ]]; then
        echo "Warnung: Sie sind nicht im hero8-Projektverzeichnis!"
        echo "Aktuelles Verzeichnis: $current_dir"
        echo "Soll ich trotzdem fortfahren? (j/n)"
        read -r response
        if [[ "$response" != "j" && "$response" != "J" ]]; then
            echo "Abgebrochen."
            exit 1
        fi
    fi
}

# Funktion für sichere Sicherung
perform_safe_backup() {
    local timestamp=$(date +%Y-%m-%d_%H-%M-%S)
    echo "Sicherung gestartet: $(date)" >> "$LOG_FILE"
    
    cd "$PROJECT_ROOT" || exit
    
    # Prüfe Git-Status
    if git status --porcelain | grep -q '^.[^ ]'; then
        echo "Änderungen gefunden. Erstelle Sicherung..."
        
        git add .
        git commit -m "Manuelle Sicherung $timestamp"
        
        if git push; then
            echo "✅ Sicherung erfolgreich gepusht."
            echo "Sicherung erfolgreich: $timestamp" >> "$LOG_FILE"
        else
            echo "❌ Fehler beim Push. Versuchen Sie es später erneut."
            echo "Push fehlgeschlagen: $timestamp" >> "$LOG_FILE"
        fi
    else
        echo "Keine Änderungen zu sichern."
        echo "Keine Änderungen: $timestamp" >> "$LOG_FILE"
    fi
}

# Hauptprogramm
echo "Hero8 Sichere Sitzungs-Sicherung"
echo "--------------------------------"

check_current_project
perform_safe_backup

echo "Sicherungsvorgang abgeschlossen."
