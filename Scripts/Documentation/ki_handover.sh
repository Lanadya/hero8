
#!/bin/bash

# ki_handover.sh - Optimiertes KI-Übergabeskript für hero8
# Erstellt am: 2025-04-19
# Erweitert um wichtige Status-Checks für hero8 und xcode-reference

PROJECT_ROOT="/Users/ninaklee/Projects/hero8"
XREF_ROOT="/Users/ninaklee/Projects/xcode-reference"
DOC_DIR="$PROJECT_ROOT/Dokumentation"
SCRIPTS_DIR="$PROJECT_ROOT/Scripts/Documentation"
BACKUP_DIR="$PROJECT_ROOT/Backups"

# Erstelle Dokumentationsverzeichnis falls nicht vorhanden
mkdir -p "$DOC_DIR"

# Aktuelles Datum und Zeit für Dateinamen
timestamp=$(date "+%Y-%m-%d_%H-%M-%S")
OUTPUT_FILE="$DOC_DIR/KI-UEBERGABE-${timestamp}.md"

# Führe das bestehende prepare_ki_transition_updated.sh Script aus
if [ -f "$SCRIPTS_DIR/prepare_ki_transition_updated.sh" ]; then
    echo "Erstelle Basis-Übergabedokumentation..."
    "$SCRIPTS_DIR/prepare_ki_transition_updated.sh"
else
    echo "Fehler: prepare_ki_transition_updated.sh nicht gefunden!"
    exit 1
fi

# Finde die neueste Übergabedatei (die gerade erstellt wurde)
latest_file=$(ls -t "$DOC_DIR/KI-UEBERGABE-"*.md | head -n 1)

# Ergänze erweiterte Informationen
if [ -f "$latest_file" ]; then
    # Kritische Warnung prominent an den Anfang
    sed -i '' '2i\
    ## KRITISCHE WARNUNG\
    - **Chats können schlagartig enden**\
    - **Regelmäßige Zwischenspeicherung ist essentiell**\
    - **Automatisierte Scripts aktiv: secure_auto_push.sh, autosave_project.sh**\
    \
    ' "$latest_file"

# After the KRITISCHE WARNUNG section (around line 30-40 depending on your script)

# Add Current Active Work status from dedicated file
if [ -f "$DOC_DIR/Status/CURRENT_ACTIVE_WORK.md" ]; then
    echo "" >> "$latest_file"
    cat "$DOC_DIR/Status/CURRENT_ACTIVE_WORK.md" >> "$latest_file"
    echo "" >> "$latest_file"
else
    echo "" >> "$latest_file"
    echo "## CURRENT ACTIVE WORK: No specific active task defined" >> "$latest_file"
    echo "" >> "$latest_file"
    echo "Please update the current work status by editing:" >> "$latest_file"
    echo "$DOC_DIR/Status/CURRENT_ACTIVE_WORK.md" >> "$latest_file"
    echo "" >> "$latest_file"
fi
    
    # Füge wichtige Verhaltensregeln für KI-Assistenten hinzu
    sed -i '' '/## Aktueller Stand/i\
    ## Kritische Verhaltensregeln\
    1. ALLE Fragen der Entwicklerin MÜSSEN beantwortet werden\
    2. IMMER Mausnavigation statt Tastaturkürzel erklären\
    3. REGELMÄSSIG in Git sichern\
    4. NIEMALS vorhandene Dateien überschreiben\
    5. STRUKTUR in Xcode immer visuell prüfen lassen\
    \
    ' "$latest_file"

    # Status der Automatisierungen
    {
        echo ""
        echo "## Aktive Automatisierungen"
        echo "- **Autosave**: $(pgrep -f 'autosave_project.sh' >/dev/null && echo "Läuft alle 5 Minuten" || echo "Nicht aktiv")"
        echo "- **Secure Auto Push**: $([ -f "$PROJECT_ROOT/.auto_push_config" ] && source "$PROJECT_ROOT/.auto_push_config" && echo "$AUTO_MODE" || echo "Nicht konfiguriert")"
        echo "- **Privacy Filter**: Aktiv für sensible Informationen"
        echo ""
    } >> "$latest_file"

    # Backup-Status
    {
        echo "## Backup-Status"
        if [ -d "$BACKUP_DIR" ]; then
            latest_backup=$(ls -t "$BACKUP_DIR"/hero8_backup_*.zip 2>/dev/null | head -1)
            backup_count=$(find "$BACKUP_DIR" -name "hero8_backup_*.zip" -mtime -1 | wc -l | tr -d ' ')
            echo "- Letztes automatisches Backup: $([ -n "$latest_backup" ] && stat -f "%Sm" "$latest_backup" || echo "Kein Backup gefunden")"
            echo "- Backup-Verzeichnis: $BACKUP_DIR"
            echo "- Aktive Backups der letzten 24h: $backup_count"
        else
            echo "- Backup-Verzeichnis nicht gefunden"
        fi
        echo ""
    } >> "$latest_file"

    # xcode-reference Status
    {
        echo "## xcode-reference Repository Status"
        if [ -d "$XREF_ROOT" ]; then
            cd "$XREF_ROOT"
            echo "- Pfad: $XREF_ROOT"
            echo "- Branch: $(git branch --show-current)"
            echo "- Letzter Commit: $(git log -1 --pretty=format:'%h - %s (%cr)')"
            echo "- Ungespeicherte Änderungen: $(git status --porcelain | wc -l | tr -d ' ')"
        else
            echo "- WARNUNG: xcode-reference Repository nicht gefunden!"
        fi
        echo ""
        cd "$PROJECT_ROOT"
    } >> "$latest_file"

    # Framework-Abhängigkeiten Visualisierung
    {
        echo "## Framework-Abhängigkeiten"
        echo "\`\`\`"
        echo "                    +---------------+"
        echo "                    |   hero8 App   |"
        echo "                    +---------------+"
        echo "                           |"
        echo "                    +---------------+"
        echo "                    |  CoreDomain   |"
        echo "                    +---------------+"
        echo "                    /              \\"
        echo "        +-----------------+    +--------------+"
        echo "        |CoreInfrastructure|    | HeroCoreData |"
        echo "        +-----------------+    +--------------+"
        echo "\`\`\`"
        echo ""
    } >> "$latest_file"

    # Wichtige Referenzen (bestehend, aber erweitert)
    sed -i '' '/## Wichtige Referenzen/,/^$/c\
    ## Wichtige Referenzen\
    1. Xcode-Reference Repository: /Users/ninaklee/Projects/xcode-reference\
    2. KI-Verhaltensregeln: /Users/ninaklee/Projects/hero8/Dokumentation/KI-WICHTIGE-REGELN.md\
    3. Entwicklerpräferenzen: /Users/ninaklee/Projects/hero8/Dokumentation/KI-PRÄFERENZEN-UND-UMGEBUNG.md\
    4. Workflow-Skripte: /Users/ninaklee/Projects/hero8/Scripts/\
    \
    ' "$latest_file"

    # Erweitere den Übergabe-Befehl
    sed -i '' 's/Bitte lies: [^`]*/Bitte lies in dieser Reihenfolge:/' "$latest_file"
    sed -i '' '/Bitte lies in dieser Reihenfolge:/a\
    1. '"$latest_file"'\
    2. /Users/ninaklee/Projects/hero8/Dokumentation/KI-WICHTIGE-REGELN.md\
    3. /Users/ninaklee/Projects/hero8/Dokumentation/KI-PRÄFERENZEN-UND-UMGEBUNG.md\
    ' "$latest_file"
fi

# Commit und Push der Änderungen
echo "Sichere alle Änderungen..."
cd "$PROJECT_ROOT"
git add .
git commit -m "KI-Übergabe: Aktueller Stand - $timestamp (erweitert)"
git push

# Vorbereitung der Übergabe-Information für die Zwischenablage (wenn pbcopy verfügbar ist)
if command -v pbcopy &> /dev/null; then
    echo "Bitte lies in dieser Reihenfolge:
1. $latest_file
2. /Users/ninaklee/Projects/hero8/Dokumentation/KI-WICHTIGE-REGELN.md
3. /Users/ninaklee/Projects/hero8/Dokumentation/KI-PRÄFERENZEN-UND-UMGEBUNG.md" | pbcopy
    echo "✓ Erweiterter Übergabe-Befehl in die Zwischenablage kopiert!"
else
    echo "Übergabe-Befehl für nächste Session:"
    echo "----------------------------------------"
    echo "Bitte lies in dieser Reihenfolge:"
    echo "1. $latest_file"
    echo "2. /Users/ninaklee/Projects/hero8/Dokumentation/KI-WICHTIGE-REGELN.md"
    echo "3. /Users/ninaklee/Projects/hero8/Dokumentation/KI-PRÄFERENZEN-UND-UMGEBUNG.md"
    echo "----------------------------------------"
fi

# Abschlussmeldung
echo ""
echo "✅ Erweiterte KI-Übergabe erfolgreich vorbereitet!"
echo "   Dokumentation: $latest_file"
echo "   Änderungen gepusht: Ja"
echo "   Wichtige xcode-reference Status: $([ -d "$XREF_ROOT" ] && echo "Geprüft" || echo "⚠️ Verzeichnis fehlt")"
echo "   Automations-Status: $(pgrep -f 'autosave_project.sh' >/dev/null && echo "Autosave läuft" || echo "Autosave nicht aktiv")"
echo "   Erweiterter Übergabe-Befehl: Siehe oben oder in Zwischenablage"
echo ""
echo "NÄCHSTER SCHRITT: Starten Sie eine neue KI-Session und verwenden Sie den erweiterten Übergabe-Befehl."
echo ""
echo "💡 TIPP: Der erweiterte Befehl enthält jetzt alle kritischen Dokumente in der richtigen Reihenfolge!"



