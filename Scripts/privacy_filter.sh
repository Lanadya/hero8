#!/bin/bash

# privacy_filter.sh - Filtert persönliche Informationen aus Dokumentation
# Verwendet ein konfigurierbares Regelset zum Schutz sensibler Daten

SCRIPT_DIR="$(dirname "$0")"
FILTER_CONFIG="$SCRIPT_DIR/privacy_filter_config.json"

# Standardfilterregeln wenn keine Konfiguration vorhanden
DEFAULT_FILTERS=(
    '/Users/[^/]+/' 
    'git@[^:]+:[^/]+/'
    '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}'
    'Bearer [A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+'
    'basic [A-Za-z0-9+/=]+'
    'token\s*[:=]\s*"?[A-Za-z0-9_-]+"?'
)

# Funktion: Filterregel anwenden
apply_filter() {
    local content="$1"
    local pattern="$2"
    local replacement="$3"
    
    echo "$content" | sed -E "s|$pattern|$replacement|g"
}

# Funktion: Alle Filterregeln auf Datei anwenden
filter_file() {
    local input_file="$1"
    local output_file="$2"
    
    if [ ! -f "$input_file" ]; then
        echo "Fehler: Eingabedatei nicht gefunden: $input_file"
        return 1
    fi
    
    # Dateiinhalt lesen
    local content=$(cat "$input_file")
    
    # Filterregeln anwenden
    content=$(apply_filter "$content" "/Users/[^/]+" "/Users/<USER>")
    content=$(apply_filter "$content" "git@[^:]+:[^/]+/" "git@<git-server>:<user>/")
    content=$(apply_filter "$content" "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}" "<email-removed>")
    content=$(apply_filter "$content" "Bearer [A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+" "Bearer <token-removed>")
    content=$(apply_filter "$content" "basic [A-Za-z0-9+/=]+" "basic <credentials-removed>")
    content=$(apply_filter "$content" "token\s*[:=]\s*\"?[A-Za-z0-9_-]+\"?" "token: <token-removed>")
    
    # Spezielle Behandlung für API-Keys und Passwörter
    content=$(apply_filter "$content" "api_key\s*[:=]\s*\"?[A-Za-z0-9_-]+\"?" "api_key: <key-removed>")
    content=$(apply_filter "$content" "password\s*[:=]\s*\"?[^\s\"]+\"?" "password: <password-removed>")
    
    # Gefilterten Inhalt in Ausgabedatei schreiben
    echo "$content" > "$output_file"
    
    # Logging der geänderten Bereiche (optional)
    if [ "$3" == "--verbose" ]; then
        echo "Gefilterte Datei: $input_file"
        diff -u "$input_file" "$output_file" || true
    fi
}

# Funktion: Rekursives Filtern eines Verzeichnisses
filter_directory() {
    local input_dir="$1"
    local output_dir="$2"
    local verbose="$3"
    
    # Erstelle Ausgabeverzeichnis wenn nicht vorhanden
    mkdir -p "$output_dir"
    
    # Verarbeite alle Dateien rekursiv
    find "$input_dir" -type f -name "*.md" | while read -r file; do
        # Berechne relativen Pfad für Ausgabedatei
        local relative_path="${file#$input_dir/}"
        local output_file="$output_dir/$relative_path"
        
        # Erstelle Unterverzeichnisse wenn nötig
        mkdir -p "$(dirname "$output_file")"
        
        # Filtere die Datei
        filter_file "$file" "$output_file" "$verbose"
    done
}

# Hauptprogramm
if [ "$#" -lt 2 ]; then
    echo "Verwendung: $0 <eingabe> <ausgabe> [--verbose]"
    echo "  eingabe: Datei oder Verzeichnis zum Filtern"
    echo "  ausgabe: Ziel für gefilterte Ausgabe"
    exit 1
fi

INPUT="$1"
OUTPUT="$2"
VERBOSE="$3"

if [ -d "$INPUT" ]; then
    filter_directory "$INPUT" "$OUTPUT" "$VERBOSE"
else
    filter_file "$INPUT" "$OUTPUT" "$VERBOSE"
fi

echo "Filterung abgeschlossen. Ausgabe in: $OUTPUT"