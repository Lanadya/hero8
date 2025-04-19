#!/bin/bash

# xcode-ref.sh - Zentrale Steuerung für Xcode-Referenz-Repository
# Ermöglicht Verwaltung des Xcode-Referenz-Repositories direkt aus hero8

# WICHTIG: Dieses Skript verbindet hero8 mit dem xcode-reference Repository
# FUTURE KI: NICHT ÜBERSCHREIBEN - Zentrale Komponente für Xcode-Dokumentation

HERO8_DIR="/Users/ninaklee/Projects/hero8"
XCODE_REF_DIR="/Users/ninaklee/Projects/xcode-reference"
CURRENT_VERSION="16.3"

# Funktion: Prüfen, ob wir im hero8 Verzeichnis sind
check_hero8_dir() {
    if [ "$(pwd)" != "$HERO8_DIR" ]; then
        echo "Bitte führen Sie dieses Skript aus dem hero8-Hauptverzeichnis aus."
        echo "Aktuelles Verzeichnis: $(pwd)"
        echo "Erforderlich: $HERO8_DIR"
        exit 1
    fi
}

# Funktion: Änderungen pushen
push_changes() {
    local message=$1
    
    if [ -z "$message" ]; then
        echo "Verwendung: $0 push <commit-nachricht>"
        exit 1
    fi
    
    (
        cd "$XCODE_REF_DIR"
        git add .
        git commit -m "$message"
        git push
    )
}

# Funktion: Screenshot hinzufügen
add_screenshot() {
    local category=$1
    local filename=$2
    
    if [ -z "$category" ] || [ -z "$filename" ]; then
        echo "Verwendung: $0 add-screenshot <kategorie> <dateiname>"
        echo "Beispiel: $0 add-screenshot frameworks 'target-dependencies.png'"
        exit 1
    fi
    
    # Zielverzeichnis erstellen wenn nicht vorhanden
    mkdir -p "$XCODE_REF_DIR/versions/$CURRENT_VERSION/images/$category"
    
    # Datei muss im aktuellen Verzeichnis existieren
    if [ ! -f "$filename" ]; then
        echo "Datei nicht gefunden: $filename"
        exit 1
    fi
    
    # Screenshot kopieren
    cp "$filename" "$XCODE_REF_DIR/versions/$CURRENT_VERSION/images/$category/"
    echo "Screenshot hinzugefügt: versions/$CURRENT_VERSION/images/$category/$filename"
}

# Funktion: Dokumentation hinzufügen
add_docs() {
    local path=$1
    local filename=$2
    
    if [ -z "$path" ] || [ -z "$filename" ]; then
        echo "Verwendung: $0 add-docs <pfad> <dateiname>"
        echo "Beispiel: $0 add-docs features 'swiftui-5.0.md'"
        exit 1
    fi
    
    # Zielverzeichnis erstellen wenn nicht vorhanden
    mkdir -p "$XCODE_REF_DIR/versions/$CURRENT_VERSION/docs/$path"
    
    # Datei muss im aktuellen Verzeichnis existieren
    if [ ! -f "$filename" ]; then
        echo "Datei nicht gefunden: $filename"
        exit 1
    fi
    
    # Dokumentation kopieren
    cp "$filename" "$XCODE_REF_DIR/versions/$CURRENT_VERSION/docs/$path/"
    echo "Dokumentation hinzugefügt: versions/$CURRENT_VERSION/docs/$path/$filename"
}

# Funktion: Neue Version hinzufügen
add_version() {
    local version=$1
    
    if [ -z "$version" ]; then
        echo "Verwendung: $0 add-version <version>"
        echo "Beispiel: $0 add-version 16.7"
        exit 1
    fi
    
    # Skript im xcode-reference Verzeichnis ausführen
    (cd "$XCODE_REF_DIR/scripts" && ./add_version.sh "$version")
}

# Funktion: Status anzeigen
show_status() {
    echo "=== Xcode Reference Repository Status ==="
    (cd "$XCODE_REF_DIR" && git status)
    echo ""
    echo "=== Aktuelle Version: $CURRENT_VERSION ==="
    echo "Screenshots:"
    find "$XCODE_REF_DIR/versions/$CURRENT_VERSION/images" -type f -name "*.png" | sed "s|$XCODE_REF_DIR/||g"
    echo ""
    echo "Dokumentation:"
    find "$XCODE_REF_DIR/versions/$CURRENT_VERSION/docs" -type f -name "*.md" | sed "s|$XCODE_REF_DIR/||g"
}

# Funktion: Chat-Session verarbeiten
process_session() {
    local session_file=$1
    
    if [ -z "$session_file" ] || [ ! -f "$session_file" ]; then
        echo "Verwendung: $0 process-session <session-datei>"
        exit 1
    fi
    
    echo "Verarbeite Session-Datei: $session_file"
    
    # Extrahiere Datum aus Dateiname
    session_date=$(basename "$session_file" | sed 's/XCODE_SESSION_\(.*\)\.md/\1/')
    
    # Erstelle Zielverzeichnis für diese Session
    session_dir="$XCODE_REF_DIR/versions/$CURRENT_VERSION/sessions/${session_date}"
    mkdir -p "$session_dir"
    
    # Kopiere Session-Zusammenfassung
    cp "$session_file" "$session_dir/summary.md"
    
    # Erstelle Index-Eintrag für diese Session
    index_file="$XCODE_REF_DIR/versions/$CURRENT_VERSION/sessions/INDEX.md"
    if [ ! -f "$index_file" ]; then
        echo "# Session Index" > "$index_file"
        echo "" >> "$index_file"
    fi
    
    echo "- [${session_date}](${session_date}/summary.md) - $(head -n 1 "$session_file" | sed 's/# //')" >> "$index_file"
    
    echo "Session erfolgreich in Referenz-Repository übernommen."
    
    # Optionaler Auto-Push
    if [ -f "$HERO8_DIR/.auto_push_config" ]; then
        source "$HERO8_DIR/.auto_push_config"
        if [ "$AUTO_MODE" != "disabled" ]; then
            echo "Führe automatischen Push aus..."
            "$HERO8_DIR/Scripts/secure_auto_push.sh" push "$XCODE_REF_DIR" "Session ${session_date} hinzugefügt"
        else
            echo "Auto-Push ist deaktiviert. Sie können die Änderungen manuell mit './xcode-ref.sh push \"Session ${session_date} hinzugefügt\"' pushen."
        fi
    else
        echo "Sie können die Änderungen mit './xcode-ref.sh push \"Session ${session_date} hinzugefügt\"' pushen."
    fi
}

# Funktion: Neuen Screenshot-Verweis erstellen
create_screenshot_reference() {
    local description=$1
    local timestamp=$(date "+%Y-%m-%d_%H-%M-%S")
    local reference="screenshot_${timestamp}"
    
    if [ -z "$description" ]; then
        echo "Verwendung: $0 create-screenshot-ref <beschreibung>"
        exit 1
    fi
    
    echo "SCREENSHOT_REF|$reference|$description" >> "$HERO8_DIR/.xcode-session/current_session.log"
    echo "Screenshot-Referenz erstellt: $reference"
    echo "Bitte fügen Sie den Screenshot im Chat ein und referenzieren Sie ihn mit: $reference"
}

# Funktion: Feature markieren
mark_feature() {
    local description=$1
    local content=$2
    
    if [ -z "$description" ] || [ -z "$content" ]; then
        echo "Verwendung: $0 mark-feature <beschreibung> <inhalt>"
        exit 1
    fi
    
    "$HERO8_DIR/Scripts/extract_xcode_info.sh" mark feature "$content" "$description"
}

# Hauptprogramm
check_hero8_dir

case "$1" in
    "add-screenshot")
        add_screenshot "$2" "$3"
        ;;
    "add-docs")
        add_docs "$2" "$3"
        ;;
    "add-version")
        add_version "$2"
        ;;
    "status")
        show_status
        ;;
    "process-session")
        process_session "$2"
        ;;
    "create-screenshot-ref")
        create_screenshot_reference "$2"
        ;;
    "mark-feature")
        mark_feature "$2" "$3"
        ;;
    "secure-push")
        "$HERO8_DIR/Scripts/secure_auto_push.sh" push "$XCODE_REF_DIR" "$2"
        ;;
    "configure-auto-push")
        "$HERO8_DIR/Scripts/secure_auto_push.sh" configure
        ;;
    *)
        echo "Xcode Reference Verwaltung aus hero8"
        echo ""
        echo "Verfügbare Befehle:"
        echo "  process-session <datei>                 - Chat-Session verarbeiten"
        echo "  create-screenshot-ref <beschreibung>    - Screenshot-Referenz erstellen"
        echo "  mark-feature <beschreibung> <inhalt>    - Feature aus Chat markieren"
        echo "  add-screenshot <kategorie> <dateiname>  - Screenshot hinzufügen"
        echo "  add-docs <pfad> <dateiname>            - Dokumentation hinzufügen"
        echo "  add-version <version>                  - Neue Version einrichten"
        echo "  status                                 - Status anzeigen"
        echo "  secure-push <nachricht>                 - Sicherer Push mit Datenschutzfilter"
        echo "  configure-auto-push                     - Auto-Push-Einstellungen konfigurieren"
        echo ""
        echo "Aktuelle Version: $CURRENT_VERSION"
        exit 1
        ;;
esac