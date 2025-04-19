#!/bin/bash

# secure_auto_push.sh - Automatisches Git-Push mit Datenschutzfilter
# Kombiniert Automatisierung mit Privatsphärenschutz

SCRIPT_DIR="$(dirname "$0")"
HERO8_DIR="/Users/ninaklee/Projects/hero8"
XCODE_REF_DIR="/Users/ninaklee/Projects/xcode-reference"
TEMP_DIR="$HERO8_DIR/.temp_push"
FILTER_LOG="$HERO8_DIR/.filter_log"

# Funktion: Prüfen und Filtern der zu pushenden Dateien
prepare_push() {
    local repo_dir="$1"
    local commit_message="$2"
    
    # Temporäres Verzeichnis erstellen
    rm -rf "$TEMP_DIR"
    mkdir -p "$TEMP_DIR"
    
    # Sammle alle zu committenden Dateien
    cd "$repo_dir"
    git status --porcelain | while read -r line; do
        # Extrahiere Dateinamen
        local file=$(echo "$line" | sed 's/^...//')
        
        if [ -f "$file" ] && [[ "$file" == *.md ]]; then
            # Filtere sensible Informationen
            "$SCRIPT_DIR/privacy_filter.sh" "$file" "$TEMP_DIR/$file"
            
            # Protokolliere Filter-Ergebnisse
            echo "Gefiltert: $file" >> "$FILTER_LOG"
            
            # Vergleiche Original mit gefilterter Version
            if ! diff -q "$file" "$TEMP_DIR/$file" >/dev/null; then
                echo "ACHTUNG: Sensible Daten gefunden in: $file" >> "$FILTER_LOG"
                
                # Optional: Zeige Unterschiede zur Überprüfung
                if [ "$AUTO_APPROVE" != "true" ]; then
                    echo "Änderungen in $file:"
                    diff -u "$file" "$TEMP_DIR/$file" | grep "^[-+]" | head -n 10
                    echo
                    read -p "Gefilterte Version verwenden? (j/n) " choice
                    if [[ "$choice" =~ ^[Jj]$ ]]; then
                        cp "$TEMP_DIR/$file" "$file"
                    fi
                else
                    # Automatisch ersetzen wenn AUTO_APPROVE gesetzt
                    cp "$TEMP_DIR/$file" "$file"
                fi
            fi
        fi
    done
}

# Funktion: Sicheres Auto-Push
secure_push() {
    local repo_dir="$1"
    local commit_message="$2"
    local auto_approve="${3:-false}"
    
    export AUTO_APPROVE="$auto_approve"
    
    # Zeitstempel für Protokoll
    echo "===== Auto-Push gestartet: $(date) =====" >> "$FILTER_LOG"
    
    # Dateien vorbereiten und filtern
    prepare_push "$repo_dir" "$commit_message"
    
    # Git-Operationen durchführen
    cd "$repo_dir"
    git add .
    
    # Commit wenn Änderungen vorhanden
    if [[ -n $(git status --porcelain) ]]; then
        git commit -m "$commit_message"
        
        # Push durchführen
        git push
        
        echo "Push erfolgreich abgeschlossen"
        echo "Filter-Log: $FILTER_LOG"
    else
        echo "Keine Änderungen zum Pushen"
    fi
    
    # Aufräumen
    rm -rf "$TEMP_DIR"
}

# Funktion: Konfigurieren der Auto-Push-Einstellungen
configure_auto_push() {
    local config_file="$HERO8_DIR/.auto_push_config"
    
    echo "Auto-Push Konfiguration"
    echo "1. Vollautomatisch (gefilterte Daten werden automatisch ersetzt)"
    echo "2. Mit Bestätigung (Überprüfung gefilterter Daten vor dem Push)"
    echo "3. Deaktiviert (manueller Push erforderlich)"
    
    read -p "Wählen Sie eine Option (1-3): " option
    
    case $option in
        1)
            echo "AUTO_MODE=full" > "$config_file"
            echo "AUTO_APPROVE=true" >> "$config_file"
            ;;
        2)
            echo "AUTO_MODE=confirm" > "$config_file"
            echo "AUTO_APPROVE=false" >> "$config_file"
            ;;
        3)
            echo "AUTO_MODE=disabled" > "$config_file"
            ;;
        *)
            echo "Ungültige Option. Behalte aktuelle Konfiguration."
            ;;
    esac
}

# Funktion: Auto-Push-Status prüfen
check_auto_push_status() {
    local config_file="$HERO8_DIR/.auto_push_config"
    
    if [ -f "$config_file" ]; then
        echo "Aktuelle Auto-Push-Konfiguration:"
        cat "$config_file"
    else
        echo "Auto-Push ist nicht konfiguriert. Standardmodus: Mit Bestätigung"
    fi
}

# Hauptprogramm
case "$1" in
    "push")
        # Prüfe Konfiguration
        if [ -f "$HERO8_DIR/.auto_push_config" ]; then
            source "$HERO8_DIR/.auto_push_config"
        else
            AUTO_MODE="confirm"
            AUTO_APPROVE="false"
        fi
        
        if [ "$AUTO_MODE" == "disabled" ]; then
            echo "Auto-Push ist deaktiviert. Bitte verwenden Sie manuellen Push."
            exit 1
        fi
        
        secure_push "$2" "$3" "$AUTO_APPROVE"
        ;;
    "configure")
        configure_auto_push
        ;;
    "status")
        check_auto_push_status
        ;;
    *)
        echo "Sicheres Auto-Push für Xcode-Referenz"
        echo ""
        echo "Verwendung:"
        echo "  $0 push <repo-verzeichnis> <commit-nachricht> - Führt sicheren Push durch"
        echo "  $0 configure                                   - Konfiguriert Auto-Push-Einstellungen"
        echo "  $0 status                                      - Zeigt aktuelle Konfiguration"
        ;;
esac