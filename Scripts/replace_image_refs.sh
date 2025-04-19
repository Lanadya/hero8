#!/bin/bash

# Ersetzt Bild-Markdown-Referenzen durch textuelle Referenzen
# Verwendung: ./replace_image_refs.sh <datei>

file=$1

if [ -z "$file" ]; then
    echo "Verwendung: $0 <datei>"
    exit 1
fi

# Ersetzt ![text](path) durch **Referenz**: [text]
sed -i '' 's/!\[\([^]]*\)\]([^)]*)/\*\*Referenz\*\*: [\1]/g' "$file"

echo "Bild-Referenzen wurden in textuelle Referenzen umgewandelt in: $file"
