#!/bin/bash

# update_docs.sh - Aktualisiert die Dokumentation mit dem aktuellen Migrationsstand

# Formatierung für bessere Lesbarkeit
BOLD=$(tput bold)
GREEN=$(tput setaf 2)
BLUE=$(tput setaf 4)
RESET=$(tput sgr0)

# Aktuellen Zeitstempel erstellen
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# Parameter prüfen
if [ -z "$1" ]; then
    echo "${BOLD}Bitte geben Sie eine Zusammenfassung der Änderungen an${RESET}"
    echo "Beispiel: ./update_docs.sh \"Migration der Repository-Klassen abgeschlossen\""
    exit 1
fi

SUMMARY="$1"
DOC_FILE="../Dokumentation/MIGRATIONSSTAND.md"

# Prüfen, ob das Dokumentationsverzeichnis existiert
if [ ! -d "../Dokumentation" ]; then
    echo "${BLUE}Erstelle Dokumentationsverzeichnis...${RESET}"
    mkdir -p "../Dokumentation"
fi

# Prüfen, ob die Dokumentationsdatei existiert
if [ ! -f "$DOC_FILE" ]; then
    echo "${BLUE}Erstelle neue Dokumentationsdatei...${RESET}"
    echo "# hero8 Migrations-Dokumentation" > "$DOC_FILE"
    echo "" >> "$DOC_FILE"
    echo "Diese Datei dokumentiert den Fortschritt der Migration von hero6 zu hero8." >> "$DOC_FILE"
    echo "" >> "$DOC_FILE"
    echo "## Migrationsfortschritt" >> "$DOC_FILE"
    echo "" >> "$DOC_FILE"
fi

# Aktualisiere die Dokumentation
echo "${BLUE}Aktualisiere Dokumentation...${RESET}"
echo "" >> "$DOC_FILE"
echo "### $TIMESTAMP" >> "$DOC_FILE"
echo "" >> "$DOC_FILE"
echo "**Zusammenfassung:** $SUMMARY" >> "$DOC_FILE"
echo "" >> "$DOC_FILE"

# Komponenten-Status-Liste
echo "#### Migrierte Komponenten:" >> "$DOC_FILE"
echo "" >> "$DOC_FILE"

# Domain Models
if [ -f "../CoreDomain/Models/DomainModels.swift" ]; then
    echo "- [x] Domain Models" >> "$DOC_FILE"
else
    echo "- [ ] Domain Models" >> "$DOC_FILE"
fi

# Repository Protocols
if [ -f "../CoreDomain/Protocols/RepositoryProtocols.swift" ]; then
    echo "- [x] Repository Protocols" >> "$DOC_FILE"
else
    echo "- [ ] Repository Protocols" >> "$DOC_FILE"
fi

# CoreDataBaseRepository
if [ -f "../CoreInfrastructure/Repositories/CoreDataBaseRepository.swift" ]; then
    echo "- [x] CoreDataBaseRepository" >> "$DOC_FILE"
else
    echo "- [ ] CoreDataBaseRepository" >> "$DOC_FILE"
fi

# FetchRequestBuilder
if [ -f "../HeroCoreData/Extensions/FetchRequestBuilder.swift" ]; then
    echo "- [x] FetchRequestBuilder" >> "$DOC_FILE"
else
    echo "- [ ] FetchRequestBuilder" >> "$DOC_FILE"
fi

# Repository Implementations
REPOS_COUNT=0
REPOS_TOTAL=4

if [ -f "../CoreInfrastructure/Repositories/CoreDataClassRepository.swift" ]; then
    echo "- [x] CoreDataClassRepository" >> "$DOC_FILE"
    ((REPOS_COUNT++))
else
    echo "- [ ] CoreDataClassRepository" >> "$DOC_FILE"
fi

if [ -f "../CoreInfrastructure/Repositories/CoreDataStudentRepository.swift" ]; then
    echo "- [x] CoreDataStudentRepository" >> "$DOC_FILE"
    ((REPOS_COUNT++))
else
    echo "- [ ] CoreDataStudentRepository" >> "$DOC_FILE"
fi

if [ -f "../CoreInfrastructure/Repositories/CoreDataRatingRepository.swift" ]; then
    echo "- [x] CoreDataRatingRepository" >> "$DOC_FILE"
    ((REPOS_COUNT++))
else
    echo "- [ ] CoreDataRatingRepository" >> "$DOC_FILE"
fi

if [ -f "../CoreInfrastructure/Repositories/CoreDataSeatingRepository.swift" ]; then
    echo "- [x] CoreDataSeatingRepository" >> "$DOC_FILE"
    ((REPOS_COUNT++))
else
    echo "- [ ] CoreDataSeatingRepository" >> "$DOC_FILE"
fi

# Core Data Models
MODELS_COUNT=0
MODELS_TOTAL=4

if [ -f "../HeroCoreData/Models/Class+CoreDataClass.swift" ]; then
    echo "- [x] Class CoreData Model" >> "$DOC_FILE"
    ((MODELS_COUNT++))
else
    echo "- [ ] Class CoreData Model" >> "$DOC_FILE"
fi

if [ -f "../HeroCoreData/Models/Student+CoreDataClass.swift" ]; then
    echo "- [x] Student CoreData Model" >> "$DOC_FILE"
    ((MODELS_COUNT++))
else
    echo "- [ ] Student CoreData Model" >> "$DOC_FILE"
fi

if [ -f "../HeroCoreData/Models/Rating+CoreDataClass.swift" ]; then
    echo "- [x] Rating CoreData Model" >> "$DOC_FILE"
    ((MODELS_COUNT++))
else
    echo "- [ ] Rating CoreData Model" >> "$DOC_FILE"
fi

if [ -f "../HeroCoreData/Models/SeatingPosition+CoreDataClass.swift" ]; then
    echo "- [x] SeatingPosition CoreData Model" >> "$DOC_FILE"
    ((MODELS_COUNT++))
else
    echo "- [ ] SeatingPosition CoreData Model" >> "$DOC_FILE"
fi

# ThreadSafeAssetManager
if [ -f "../Core/AssetManager/ThreadSafeAssetManager.swift" ]; then
    echo "- [x] ThreadSafeAssetManager" >> "$DOC_FILE"
else
    echo "- [ ] ThreadSafeAssetManager" >> "$DOC_FILE"
fi

# Persistence Controller
if [ -f "../HeroCoreData/Persistence/PersistenceController.swift" ]; then
    echo "- [x] PersistenceController" >> "$DOC_FILE"
else
    echo "- [ ] PersistenceController" >> "$DOC_FILE"
fi

# UI Components
echo "" >> "$DOC_FILE"
echo "#### Allgemeiner Fortschritt:" >> "$DOC_FILE"
echo "" >> "$DOC_FILE"

# Berechne den Gesamtfortschritt
PROGRESS=0

if [ -f "../CoreDomain/Models/DomainModels.swift" ]; then
    ((PROGRESS+=10))
fi

if [ -f "../CoreDomain/Protocols/RepositoryProtocols.swift" ]; then
    ((PROGRESS+=10))
fi

if [ -f "../CoreInfrastructure/Repositories/CoreDataBaseRepository.swift" ]; then
    ((PROGRESS+=10))
fi

if [ -f "../HeroCoreData/Extensions/FetchRequestBuilder.swift" ]; then
    ((PROGRESS+=5))
fi

# Repository Implementations (20% insgesamt)
REPOS_PERCENTAGE=$((REPOS_COUNT * 5))
PROGRESS=$((PROGRESS + REPOS_PERCENTAGE))

# Core Data Models (20% insgesamt)
MODELS_PERCENTAGE=$((MODELS_COUNT * 5))
PROGRESS=$((PROGRESS + MODELS_PERCENTAGE))

if [ -f "../Core/AssetManager/ThreadSafeAssetManager.swift" ]; then
    ((PROGRESS+=15))
fi

if [ -f "../HeroCoreData/Persistence/PersistenceController.swift" ]; then
    ((PROGRESS+=10))
fi

# Fortschrittsbalken anzeigen
echo "Gesamtfortschritt: $PROGRESS%" >> "$DOC_FILE"
echo "\`\`\`" >> "$DOC_FILE"
PROGRESS_BAR=$(printf '%*s' $((PROGRESS/2)) '' | tr ' ' '#')
echo "[$PROGRESS_BAR$(printf '%*s' $((50-PROGRESS/2)) '' | tr ' ' ' ')] $PROGRESS%" >> "$DOC_FILE"
echo "\`\`\`" >> "$DOC_FILE"

echo "${GREEN}Dokumentation erfolgreich aktualisiert!${RESET}"
echo "Fortschritt: $PROGRESS%"
