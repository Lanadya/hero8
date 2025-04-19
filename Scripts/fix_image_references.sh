#!/bin/bash

# fix_image_references.sh
# Korrigiert Bild-Referenzen in bestehenden Markdown-Dateien
# Angelegt am: 2025-04-19

# Erforderlicher Parameter: Pfad zum xcode-reference Repository
REPO_PATH=$1

if [ -z "$REPO_PATH" ]; then
    echo "Verwendung: $0 /pfad/zum/xcode-reference"
    exit 1
fi

# Funktion: Konvertiere Bildmarkdown in textuelle Referenzen
fix_references() {
    local file=$1
    if [ -f "$file" ]; then
        # Backup der Originaldatei
        cp "$file" "${file}.backup"
        
        # Ersetzt ![text](path) durch **Referenz**: [text]
        sed -i '' 's/!\[\([^]]*\)\]([^)]*)/\*\*Referenz\*\*: [\1]/g' "$file"
        
        # Ersetzt auch **Referenz**: [screenshot_... Links
        sed -i '' 's/\*\*Referenz\*\*: \[screenshot_\([^]]*\)\]/\*\*Referenz\*\*: [screenshot_\1]/g' "$file"
        
        echo "Korrigiert: $file"
    else
        echo "Datei nicht gefunden: $file"
    fi
}

# Navigiere zum Repository
cd "$REPO_PATH"

# Finde alle Markdown-Dateien und korrigiere sie
echo "Suche nach Markdown-Dateien im Repository..."
find versions -name "*.md" | while read -r file; do
    fix_references "$file"
done

echo ""
echo "Korrektur abgeschlossen. Bitte überprüfen Sie die Änderungen mit:"
echo "git diff"
echo ""
echo "Wenn alles korrekt aussieht, committen Sie die Änderungen mit:"
echo "git commit -am 'Fix: Use textual references instead of image links'"
echo "git push"
