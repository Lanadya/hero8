#!/bin/bash

# extract_xcode_info.sh - Extrahiert Xcode-Informationen aus KI-Chat-Sessions
# Speichert relevante Informationen zur späteren Verarbeitung

# WICHTIG: Dieses Skript hilft, Xcode-Informationen aus Chat-Sessions zu extrahieren
# NICHT ÜBERSCHREIBEN - Teil des verbesserten Workflows

HERO8_DIR="/Users/ninaklee/Projects/hero8"
XCODE_REF_DIR="/Users/ninaklee/Projects/xcode-reference"
SESSION_DIR="$HERO8_DIR/.xcode-session"
TIMESTAMP=$(date "+%Y-%m-%d_%H-%M-%S")

# Erstelle Session-Verzeichnis falls nicht vorhanden
mkdir -p "$SESSION_DIR"

# Funktion: Markiere Information als Xcode-relevant
mark_xcode_info() {
    local type=$1
    local content=$2
    local description=$3
    
    case "$type" in
        "screenshot")
            echo "XCODE_SCREENSHOT|$TIMESTAMP|$description|$content" >> "$SESSION_DIR/current_session.log"
            echo "Xcode-Screenshot markiert: $description"
            ;;
        "feature")
            echo "XCODE_FEATURE|$TIMESTAMP|$description|$content" >> "$SESSION_DIR/current_session.log"
            echo "Xcode-Feature markiert: $description"
            ;;
        "issue")
            echo "XCODE_ISSUE|$TIMESTAMP|$description|$content" >> "$SESSION_DIR/current_session.log"
            echo "Xcode-Issue markiert: $description"
            ;;
    esac
}

# Funktion: Session beenden und Informationen sammeln
finalize_session() {
    if [ ! -f "$SESSION_DIR/current_session.log" ]; then
        echo "Keine aktive Session gefunden."
        exit 1
    fi
    
    local session_doc="$HERO8_DIR/Dokumentation/XCODE_SESSION_${TIMESTAMP}.md"
    
    echo "# Xcode Session Zusammenfassung ${TIMESTAMP}" > "$session_doc"
    echo "" >> "$session_doc"
    
    # Screenshots
    echo "## Screenshots" >> "$session_doc"
    grep "^XCODE_SCREENSHOT" "$SESSION_DIR/current_session.log" | while IFS='|' read -r type ts desc content; do
        echo "- [$desc]" >> "$session_doc"
        echo "  Zeitpunkt: $ts" >> "$session_doc"
        echo "  Referenz: $content" >> "$session_doc"
        echo "" >> "$session_doc"
    done
    
    # Features
    echo "## Neue Features / Erkenntnisse" >> "$session_doc"
    grep "^XCODE_FEATURE" "$SESSION_DIR/current_session.log" | while IFS='|' read -r type ts desc content; do
        echo "### $desc" >> "$session_doc"
        echo "$content" >> "$session_doc"
        echo "" >> "$session_doc"
    done
    
    # Issues
    echo "## Probleme und Lösungen" >> "$session_doc"
    grep "^XCODE_ISSUE" "$SESSION_DIR/current_session.log" | while IFS='|' read -r type ts desc content; do
        echo "### $desc" >> "$session_doc"
        echo "$content" >> "$session_doc"
        echo "" >> "$session_doc"
    done
    
    # Archiviere die Session
    mv "$SESSION_DIR/current_session.log" "$SESSION_DIR/session_${TIMESTAMP}.log"
    
    echo "Session-Zusammenfassung erstellt: $session_doc"
    echo "Sie können die Informationen nun mit './xcode-ref.sh process-session $session_doc' ins Referenz-Repository übernehmen."
}

# Hauptprogramm
case "$1" in
    "mark")
        mark_xcode_info "$2" "$3" "$4"
        ;;
    "finalize")
        finalize_session
        ;;
    *)
        echo "Verwendung für KI-Sessions:"
        echo "  $0 mark screenshot <referenz> <beschreibung>"
        echo "  $0 mark feature <inhalt> <beschreibung>"
        echo "  $0 mark issue <inhalt> <beschreibung>"
        echo "  $0 finalize"
        ;;
esac