#!/bin/bash

# push_changes.sh - Sichert Änderungen und aktualisiert die Dokumentation

# Formatierung für bessere Lesbarkeit
BOLD=$(tput bold)
GREEN=$(tput setaf 2)
BLUE=$(tput setaf 4)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
RESET=$(tput sgr0)

# Aktuellen Zeitstempel erstellen
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# Parameter prüfen
if [ -z "$1" ]; then
    echo "${BOLD}${YELLOW}Bitte geben Sie eine Commit-Nachricht an${RESET}"
    echo "Beispiel: ./push_changes.sh \"Migration der Repository-Klassen\""
    exit 1
fi

COMMIT_MESSAGE="$1"

# Prüfen, ob wir im richtigen Verzeichnis sind
if [ ! -d "../CoreDomain" ] || [ ! -d "../CoreInfrastructure" ]; then
    echo "${RED}Fehler: Skript muss im Skripts-Ordner des hero8-Projekts ausgeführt werden.${RESET}"
    exit 1
fi

# Erstelle Sicherungskopie der wichtigsten Dateien
echo "${BLUE}Erstelle Sicherungskopie wichtiger Dateien...${RESET}"
BACKUP_DIR="../backup_$(date +"%Y%m%d_%H%M%S")"
mkdir -p "$BACKUP_DIR"
mkdir -p "$BACKUP_DIR/CoreDomain"
mkdir -p "$BACKUP_DIR/CoreInfrastructure"
mkdir -p "$BACKUP_DIR/HeroCoreData"
mkdir -p "$BACKUP_DIR/Core"

# Domain Models kopieren
if [ -d "../CoreDomain/Models" ]; then
    cp -r "../CoreDomain/Models" "$BACKUP_DIR/CoreDomain/"
fi

# Repository Protocols kopieren
if [ -d "../CoreDomain/Protocols" ]; then
    cp -r "../CoreDomain/Protocols" "$BACKUP_DIR/CoreDomain/"
fi

# Repository Implementations kopieren
if [ -d "../CoreInfrastructure/Repositories" ]; then
    cp -r "../CoreInfrastructure/Repositories" "$BACKUP_DIR/CoreInfrastructure/"
fi

# Core Data Models kopieren
if [ -d "../HeroCoreData/Models" ]; then
    cp -r "../HeroCoreData/Models" "$BACKUP_DIR/HeroCoreData/"
fi

# Persistence Controller kopieren
if [ -d "../HeroCoreData/Persistence" ]; then
    cp -r "../HeroCoreData/Persistence" "$BACKUP_DIR/HeroCoreData/"
fi

# FetchRequestBuilder kopieren
if [ -d "../HeroCoreData/Extensions" ]; then
    cp -r "../HeroCoreData/Extensions" "$BACKUP_DIR/HeroCoreData/"
fi

# ThreadSafeAssetManager kopieren
if [ -d "../Core/AssetManager" ]; then
    cp -r "../Core/AssetManager" "$BACKUP_DIR/Core/"
fi

echo "${GREEN}Sicherungskopie erstellt: $BACKUP_DIR${RESET}"

# Aktualisiere die Dokumentation
if [ -f "./update_docs.sh" ]; then
    echo "${BLUE}Aktualisiere Dokumentation...${RESET}"
    chmod +x ./update_docs.sh
    ./update_docs.sh "Automatisches Update: $COMMIT_MESSAGE"
else
    echo "${YELLOW}Warnung: update_docs.sh nicht gefunden. Dokumentation wird nicht aktualisiert.${RESET}"
fi

# Dateien auf Ausführbarkeit setzen
echo "${BLUE}Setze Skripts auf ausführbar...${RESET}"
chmod +x ./*.sh

echo "${GREEN}Änderungen erfolgreich gesichert!${RESET}"
echo "Commit-Nachricht: $COMMIT_MESSAGE"
echo "Backup-Verzeichnis: $BACKUP_DIR"
