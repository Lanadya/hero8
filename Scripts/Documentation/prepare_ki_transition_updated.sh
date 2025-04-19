#!/bin/bash

# prepare_ki_transition_updated.sh
# Skript zur Vorbereitung des KI-Übergangs für hero8
# Angelegt am: 2025-04-19

# Projektverzeichnis
PROJECT_ROOT="/Users/ninaklee/Projects/hero8"
DOC_DIR="$PROJECT_ROOT/Dokumentation"

# Erstelle Dokumentationsverzeichnis falls nicht vorhanden
mkdir -p "$DOC_DIR"

# Aktuelles Datum und Zeit
timestamp=$(date "+%Y-%m-%d_%H-%M-%S")

# Zieldatei für die Übergabedokumentation
OUTPUT_FILE="$DOC_DIR/KI-UEBERGABE-${timestamp}.md"

echo "# hero8 KI-Übergabe (${timestamp})" > "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "## Aktueller Stand" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# 1. Projektstruktur prüfen
echo "### 1. Projektstruktur" >> "$OUTPUT_FILE"
if [ -d "$PROJECT_ROOT/.git" ]; then
    echo "- hero8-Verzeichnis angelegt" >> "$OUTPUT_FILE"
    echo "- GitHub-Repository korrekt konfiguriert: $(git remote get-url origin)" >> "$OUTPUT_FILE"
    echo "- Alle Framework-Verzeichnisse vorhanden" >> "$OUTPUT_FILE"
else
    echo "- GitHub-Repository nicht konfiguriert" >> "$OUTPUT_FILE"
fi
echo "" >> "$OUTPUT_FILE"

# 2. Framework-Status prüfen
echo "### 2. Framework-Status" >> "$OUTPUT_FILE"
for framework in CoreDomain CoreInfrastructure HeroCoreData; do
    if [ -d "$PROJECT_ROOT/$framework" ]; then
        echo "- $framework: Framework angelegt" >> "$OUTPUT_FILE"
        # Prüfe auf spezifische Dateien
        if [ "$framework" = "CoreDomain" ]; then
            if [ -f "$PROJECT_ROOT/$framework/Models/DomainModels.swift" ]; then
                echo "  - Models/DomainModels.swift vorhanden" >> "$OUTPUT_FILE"
            fi
            if [ -f "$PROJECT_ROOT/$framework/Protocols/RepositoryProtocols.swift" ]; then
                echo "  - Protocols/RepositoryProtocols.swift vorhanden" >> "$OUTPUT_FILE"
            fi
        fi
    else
        echo "- $framework: Framework FEHLT" >> "$OUTPUT_FILE"
    fi
done
echo "" >> "$OUTPUT_FILE"

# 3. Nächste Schritte
echo "### 3. Nächste Schritte" >> "$OUTPUT_FILE"
echo "1. Verbleibende Frameworks vollständig implementieren" >> "$OUTPUT_FILE"
echo "2. Framework-Abhängigkeiten konfigurieren" >> "$OUTPUT_FILE"
echo "3. Build-Tests durchführen" >> "$OUTPUT_FILE"
echo "4. Migration fortsetzen" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# 4. Warnung für nächste KI
echo "### 4. Warnung für nächste KI" >> "$OUTPUT_FILE"
echo "- NICHT neu installieren" >> "$OUTPUT_FILE"
echo "- Vorhandene Dateien NICHT überschreiben" >> "$OUTPUT_FILE"
echo "- Vorsichtig vorgehen bei der Xcode-Referenzierung" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# 5. Letzte Commits
echo "### 5. Letzte Commits" >> "$OUTPUT_FILE"
cd "$PROJECT_ROOT"
git log --pretty=format:"- %s (%cr)" -n 5 >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Übergabenotizen
echo "### 6. Übergabenotizen" >> "$OUTPUT_FILE"
echo "- TODO: Aktuelle Aufgaben hier eintragen" >> "$OUTPUT_FILE"
echo "- WICHTIG: Besondere Hinweise hier dokumentieren" >> "$OUTPUT_FILE"

echo ""
echo "Übergabedokumentation erstellt: $OUTPUT_FILE"
echo "Bitte überprüfen und ggf. ergänzen."
