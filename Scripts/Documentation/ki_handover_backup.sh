#!/bin/bash

# ki_handover.sh - Optimiertes KI-Übergabeskript für hero8
# Erstellt am: 2025-04-19
# Kombiniert Dokumentation, Push und Übergabe-Vorbereitung in einem Schritt

PROJECT_ROOT="/Users/ninaklee/Projects/hero8"
DOC_DIR="$PROJECT_ROOT/Dokumentation"
SCRIPTS_DIR="$PROJECT_ROOT/Scripts/Documentation"

# Erstelle Dokumentationsverzeichnis falls nicht vorhanden
mkdir -p "$DOC_DIR"

# Aktuelles Datum und Zeit für Dateinamen
timestamp=$(date "+%Y-%m-%d_%H-%M-%S")
OUTPUT_FILE="$DOC_DIR/KI-UEBERGABE-${timestamp}.md"

# Führe das bestehende prepare_ki_transition_updated.sh Script aus
if [ -f "$SCRIPTS_DIR/prepare_ki_transition_updated.sh" ]; then
    echo "Erstelle Übergabedokumentation..."
    "$SCRIPTS_DIR/prepare_ki_transition_updated.sh"
else
    echo "Fehler: prepare_ki_transition_updated.sh nicht gefunden!"
    exit 1
fi

# Finde die neueste Übergabedatei (die gerade erstellt wurde)
latest_file=$(ls -t "$DOC_DIR/KI-UEBERGABE-"*.md | head -n 1)

# Ergänze zusätzliche Informationen
if [ -f "$latest_file" ]; then
    echo "" >> "$latest_file"
    echo "## Wichtige Referenzen" >> "$latest_file"
    echo "1. Xcode-Reference Repository: /Users/ninaklee/Projects/xcode-reference" >> "$latest_file"
    echo "2. Hauptdokumentation: /Users/ninaklee/Projects/hero8/Dokumentation/KI-PRÄFERENZEN-UND-UMGEBUNG.md" >> "$latest_file"
    echo "3. Workflow-Skripte: /Users/ninaklee/Projects/hero8/Scripts/" >> "$latest_file"
    echo "" >> "$latest_file"
    echo "## Übergabe-Befehl für nächste Session" >> "$latest_file"
    echo "\`\`\`" >> "$latest_file"
    echo "Bitte lies: $latest_file" >> "$latest_file"
    echo "\`\`\`" >> "$latest_file"
fi

# Commit und Push der Änderungen
echo "Sichere alle Änderungen..."
cd "$PROJECT_ROOT"
git add .
git commit -m "KI-Übergabe: Aktueller Stand - $timestamp"
git push

# Vorbereitung der Übergabe-Information für die Zwischenablage (wenn pbcopy verfügbar ist)
if command -v pbcopy &> /dev/null; then
    echo "Bitte lies: $latest_file" | pbcopy
    echo "✓ Übergabe-Befehl in die Zwischenablage kopiert!"
else
    echo "Übergabe-Befehl für nächste Session:"
    echo "----------------------------------------"
    echo "Bitte lies: $latest_file"
    echo "----------------------------------------"
fi

# Abschlussmeldung
echo ""
echo "✅ KI-Übergabe erfolgreich vorbereitet!"
echo "   Dokumentation: $latest_file"
echo "   Änderungen gepusht: Ja"
echo "   Übergabe-Befehl: Siehe oben oder in Zwischenablage"
echo ""
echo "NÄCHSTER SCHRITT: Starten Sie eine neue KI-Session und verwenden Sie den Übergabe-Befehl."
