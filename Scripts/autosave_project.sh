#!/bin/bash

# autosave_project.sh
# Automatische Zwischenspeicherung für hero8-Projekt
# Angelegt am: 2025-04-19

PROJECT_ROOT="/Users/ninaklee/Projects/hero8"
DOC_DIR="$PROJECT_ROOT/Dokumentation"
BACKUP_DIR="$PROJECT_ROOT/Backups"

# Backup-Verzeichnis erstellen falls nicht vorhanden
mkdir -p "$BACKUP_DIR"

# Automatische Zwischenspeicherung
autosave() {
    local timestamp=$(date "+%Y-%m-%d_%H-%M-%S")
    local message="Automatische Zwischenspeicherung ${timestamp}"
    
    # Speichere aktuellen Status
    cd "$PROJECT_ROOT"
    
    # Prüfe ob es Änderungen gibt
    if [[ -n $(git status --porcelain) ]]; then
        # Gibt es nicht committete Änderungen
        git add .
        git commit -m "$message"
        git push
        echo "[$(date)] Änderungen automatisch gespeichert und gepusht"
    else
        echo "[$(date)] Keine Änderungen zum Speichern"
    fi
    
    # Erstelle zusätzliches Backup der wichtigsten Dateien
    backup_timestamp=$(date "+%Y%m%d_%H%M%S")
    backup_zip="$BACKUP_DIR/hero8_backup_${backup_timestamp}.zip"
    
    # Zip der wichtigsten Verzeichnisse
    zip -r "$backup_zip" \
        "$PROJECT_ROOT/CoreDomain" \
        "$PROJECT_ROOT/CoreInfrastructure" \
        "$PROJECT_ROOT/HeroCoreData" \
        "$PROJECT_ROOT/Dokumentation" \
        "$PROJECT_ROOT/Scripts" \
        -x "*.git*" "*.DS_Store" "*.xcuserdata*"
    
    echo "[$(date)] Backup erstellt: $backup_zip"
}

# Wenn als Hintergrundprozess gestartet
if [ "$1" = "background" ]; then
    while true; do
        autosave
        sleep 300  # Alle 5 Minuten
    done
else
    # Einmalige Ausführung
    autosave
fi