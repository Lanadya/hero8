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
    "push")
        push_changes "$2"
        ;;
    *)
        echo "Xcode Reference Verwaltung aus hero8"
        echo ""
        echo "Verfügbare Befehle:"
        echo "  add-screenshot <kategorie> <dateiname>  - Screenshot hinzufügen"
        echo "  add-docs <pfad> <dateiname>            - Dokumentation hinzufügen"
        echo "  add-version <version>                  - Neue Version einrichten"
        echo "  status                                 - Status anzeigen"
        echo "  push <nachricht>                       - Änderungen zu GitHub pushen"
        echo ""
        echo "Aktuelle Version: $CURRENT_VERSION"
        exit 1
        ;;
esac