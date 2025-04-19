#!/bin/bash

# hero8_run.sh - Hauptskript für hero8-Projekt
# Angelegt am: 2025-04-19

# Projektverzeichnis als Basis
PROJECT_ROOT="/Users/ninaklee/Projects/hero8"

# Funktion zur Aktualisierung der Dokumentation
update_docs() {
    local message="$1"
    echo "Aktualisiere Dokumentation..."
    
    # Timestamp für Dokumentation
    timestamp=$(date "+%Y-%m-%d_%H-%M-%S")
    
    # Neues Übergabedokument erstellen
    doc_file="$PROJECT_ROOT/Dokumentation/KI-UEBERGABE-${timestamp}.md"
    
    echo "# hero8 KI-Übergabe (${timestamp})" > "$doc_file"
    echo "" >> "$doc_file"
    echo "## Beschreibung" >> "$doc_file"
    echo "$message" >> "$doc_file"
    echo "" >> "$doc_file"
    echo "## Aktueller Stand" >> "$doc_file"
    
    # Kopiere den Inhalt der letzten Übergabe
    latest_uebergabe=$(ls -t "$PROJECT_ROOT/Dokumentation/KI-UEBERGABE-"*.md 2>/dev/null | head -n 1)
    if [ -f "$latest_uebergabe" ]; then
        tail -n +3 "$latest_uebergabe" >> "$doc_file"
    fi
    
    echo "Dokumentation aktualisiert: $doc_file"
}

# Funktion zum Pushen der Änderungen
push_changes() {
    local message="$1"
    echo "Speichere Änderungen..."
    
    cd "$PROJECT_ROOT"
    git add .
    git commit -m "$message"
    git push
    
    echo "Änderungen gespeichert und gepusht!"
}

# Hauptprogramm
case "$1" in
    "update_docs")
        update_docs "$2"
        ;;
    "push_changes")
        push_changes "$2"
        ;;
    *)
        echo "Verwendung: $0 {update_docs|push_changes} [Nachricht]"
        exit 1
        ;;
esac