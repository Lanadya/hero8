#!/bin/bash

# prepare_ki_transition.sh - Erstellt eine Übergabedokumentation für den KI-Wechsel

# Formatierung für bessere Lesbarkeit
BOLD=$(tput bold)
GREEN=$(tput setaf 2)
BLUE=$(tput setaf 4)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

# Aktuellen Zeitstempel erstellen
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
TRANSITION_FILE="../Dokumentation/KI-UEBERGABE-$(date +"%Y%m%d%H%M%S").md"

# Prüfen, ob das Dokumentationsverzeichnis existiert
if [ ! -d "../Dokumentation" ]; then
    echo "${BLUE}Erstelle Dokumentationsverzeichnis...${RESET}"
    mkdir -p "../Dokumentation"
fi

# Übergabedokumentation erstellen
echo "${BLUE}Erstelle KI-Übergabedokumentation...${RESET}"
echo "# hero8 KI-Übergabedokumentation" > "$TRANSITION_FILE"
echo "" >> "$TRANSITION_FILE"
echo "Erstellt am: $TIMESTAMP" >> "$TRANSITION_FILE"
echo "" >> "$TRANSITION_FILE"
echo "## Aktueller Migrationsstand" >> "$TRANSITION_FILE"
echo "" >> "$TRANSITION_FILE"

# Komponenten-Status ermitteln und in die Dokumentation schreiben
echo "### Migrierte Komponenten:" >> "$TRANSITION_FILE"
echo "" >> "$TRANSITION_FILE"

# Domain Models
if [ -f "../CoreDomain/Models/DomainModels.swift" ]; then
    echo "- [x] Domain Models" >> "$TRANSITION_FILE"
else
    echo "- [ ] Domain Models" >> "$TRANSITION_FILE"
fi

# Repository Protocols
if [ -f "../CoreDomain/Protocols/RepositoryProtocols.swift" ]; then
    echo "- [x] Repository Protocols" >> "$TRANSITION_FILE"
else
    echo "- [ ] Repository Protocols" >> "$TRANSITION_FILE"
fi

# CoreDataBaseRepository
if [ -f "../CoreInfrastructure/Repositories/CoreDataBaseRepository.swift" ]; then
    echo "- [x] CoreDataBaseRepository" >> "$TRANSITION_FILE"
else
    echo "- [ ] CoreDataBaseRepository" >> "$TRANSITION_FILE"
fi

# FetchRequestBuilder
if [ -f "../HeroCoreData/Extensions/FetchRequestBuilder.swift" ]; then
    echo "- [x] FetchRequestBuilder" >> "$TRANSITION_FILE"
else
    echo "- [ ] FetchRequestBuilder" >> "$TRANSITION_FILE"
fi

# Repository Implementations
if [ -f "../CoreInfrastructure/Repositories/CoreDataClassRepository.swift" ]; then
    echo "- [x] CoreDataClassRepository" >> "$TRANSITION_FILE"
else
    echo "- [ ] CoreDataClassRepository" >> "$TRANSITION_FILE"
fi

if [ -f "../CoreInfrastructure/Repositories/CoreDataStudentRepository.swift" ]; then
    echo "- [x] CoreDataStudentRepository" >> "$TRANSITION_FILE"
else
    echo "- [ ] CoreDataStudentRepository" >> "$TRANSITION_FILE"
fi

if [ -f "../CoreInfrastructure/Repositories/CoreDataRatingRepository.swift" ]; then
    echo "- [x] CoreDataRatingRepository" >> "$TRANSITION_FILE"
else
    echo "- [ ] CoreDataRatingRepository" >> "$TRANSITION_FILE"
fi

if [ -f "../CoreInfrastructure/Repositories/CoreDataSeatingRepository.swift" ]; then
    echo "- [x] CoreDataSeatingRepository" >> "$TRANSITION_FILE"
else
    echo "- [ ] CoreDataSeatingRepository" >> "$TRANSITION_FILE"
fi

# Core Data Models
if [ -f "../HeroCoreData/Models/Class+CoreDataClass.swift" ]; then
    echo "- [x] Class CoreData Model" >> "$TRANSITION_FILE"
else
    echo "- [ ] Class CoreData Model" >> "$TRANSITION_FILE"
fi

if [ -f "../HeroCoreData/Models/Student+CoreDataClass.swift" ]; then
    echo "- [x] Student CoreData Model" >> "$TRANSITION_FILE"
else
    echo "- [ ] Student CoreData Model" >> "$TRANSITION_FILE"
fi

if [ -f "../HeroCoreData/Models/Rating+CoreDataClass.swift" ]; then
    echo "- [x] Rating CoreData Model" >> "$TRANSITION_FILE"
else
    echo "- [ ] Rating CoreData Model" >> "$TRANSITION_FILE"
fi

if [ -f "../HeroCoreData/Models/SeatingPosition+CoreDataClass.swift" ]; then
    echo "- [x] SeatingPosition CoreData Model" >> "$TRANSITION_FILE"
else
    echo "- [ ] SeatingPosition CoreData Model" >> "$TRANSITION_FILE"
fi

# ThreadSafeAssetManager
if [ -f "../Core/AssetManager/ThreadSafeAssetManager.swift" ]; then
    echo "- [x] ThreadSafeAssetManager" >> "$TRANSITION_FILE"
else
    echo "- [ ] ThreadSafeAssetManager" >> "$TRANSITION_FILE"
fi

# Persistence Controller
if [ -f "../HeroCoreData/Persistence/PersistenceController.swift" ]; then
    echo "- [x] PersistenceController" >> "$TRANSITION_FILE"
else
    echo "- [ ] PersistenceController" >> "$TRANSITION_FILE"
fi

# Nächste Schritte in der Migration
echo "" >> "$TRANSITION_FILE"
echo "## Nächste Schritte" >> "$TRANSITION_FILE"
echo "" >> "$TRANSITION_FILE"
echo "Basierend auf dem aktuellen Migrationsstand sind folgende Schritte als nächstes durchzuführen:" >> "$TRANSITION_FILE"
echo "" >> "$TRANSITION_FILE"

# Prüfen, welche Komponenten noch fehlen und entsprechende nächste Schritte vorschlagen
NEXT_STEPS=0

if [ ! -f "../CoreDomain/Models/DomainModels.swift" ]; then
    echo "1. Migration der Domain-Modelle aus hero6" >> "$TRANSITION_FILE"
    ((NEXT_STEPS++))
fi

if [ ! -f "../CoreDomain/Protocols/RepositoryProtocols.swift" ]; then
    echo "$((NEXT_STEPS+1)). Migration der Repository-Protokolle aus hero6" >> "$TRANSITION_FILE"
    ((NEXT_STEPS++))
fi

if [ ! -f "../CoreInfrastructure/Repositories/CoreDataBaseRepository.swift" ]; then
    echo "$((NEXT_STEPS+1)). Migration der CoreDataBaseRepository aus hero6" >> "$TRANSITION_FILE"
    ((NEXT_STEPS++))
fi

if [ ! -f "../HeroCoreData/Extensions/FetchRequestBuilder.swift" ]; then
    echo "$((NEXT_STEPS+1)). Migration des FetchRequestBuilder aus hero6" >> "$TRANSITION_FILE"
    ((NEXT_STEPS++))
fi

# Repository Implementations
REPOS_MISSING=0
if [ ! -f "../CoreInfrastructure/Repositories/CoreDataClassRepository.swift" ]; then
    ((REPOS_MISSING++))
fi
if [ ! -f "../CoreInfrastructure/Repositories/CoreDataStudentRepository.swift" ]; then
    ((REPOS_MISSING++))
fi
if [ ! -f "../CoreInfrastructure/Repositories/CoreDataRatingRepository.swift" ]; then
    ((REPOS_MISSING++))
fi
if [ ! -f "../CoreInfrastructure/Repositories/CoreDataSeatingRepository.swift" ]; then
    ((REPOS_MISSING++))
fi

if [ $REPOS_MISSING -gt 0 ]; then
    echo "$((NEXT_STEPS+1)). Migration der Repository-Implementierungen aus hero6 ($REPOS_MISSING von 4 fehlen)" >> "$TRANSITION_FILE"
    ((NEXT_STEPS++))
fi

# Core Data Models
MODELS_MISSING=0
if [ ! -f "../HeroCoreData/Models/Class+CoreDataClass.swift" ]; then
    ((MODELS_MISSING++))
fi
if [ ! -f "../HeroCoreData/Models/Student+CoreDataClass.swift" ]; then
    ((MODELS_MISSING++))
fi
if [ ! -f "../HeroCoreData/Models/Rating+CoreDataClass.swift" ]; then
    ((MODELS_MISSING++))
fi
if [ ! -f "../HeroCoreData/Models/SeatingPosition+CoreDataClass.swift" ]; then
    ((MODELS_MISSING++))
fi

if [ $MODELS_MISSING -gt 0 ]; then
    echo "$((NEXT_STEPS+1)). Migration der Core Data Modelle aus hero6 ($MODELS_MISSING von 4 fehlen)" >> "$TRANSITION_FILE"
    ((NEXT_STEPS++))
fi

if [ ! -f "../Core/AssetManager/ThreadSafeAssetManager.swift" ]; then
    echo "$((NEXT_STEPS+1)). Implementierung des ThreadSafeAssetManager" >> "$TRANSITION_FILE"
    ((NEXT_STEPS++))
fi

if [ ! -f "../HeroCoreData/Persistence/PersistenceController.swift" ]; then
    echo "$((NEXT_STEPS+1)). Migration des PersistenceController aus hero6" >> "$TRANSITION_FILE"
    ((NEXT_STEPS++))
fi

# Wenn alle Komponenten vorhanden sind, UI-Migration vorschlagen
if [ $NEXT_STEPS -eq 0 ]; then
    echo "1. Migration der UI-Komponenten und ViewModels aus hero6" >> "$TRANSITION_FILE"
    echo "2. Implementierung der Thread-sicheren Asset-Zugriffe in den UI-Komponenten" >> "$TRANSITION_FILE"
    echo "3. Testen der Gesamtapplikation" >> "$TRANSITION_FILE"
fi

# Offene Probleme
echo "" >> "$TRANSITION_FILE"
echo "## Bekannte Probleme und Herausforderungen" >> "$TRANSITION_FILE"
echo "" >> "$TRANSITION_FILE"
echo "Bei der Migration sind folgende Probleme oder Herausforderungen aufgetreten:" >> "$TRANSITION_FILE"
echo "" >> "$TRANSITION_FILE"
echo "1. CUICatalog-Fehler: Dieser wird durch den ThreadSafeAssetManager behandelt. Alle Asset-Zugriffe müssen über diesen Manager erfolgen." >> "$TRANSITION_FILE"
echo "2. CoreData-Modelle müssen mit der korrekten Version und ohne Duplikate migriert werden." >> "$TRANSITION_FILE"
echo "3. Bundle-ID muss durchgängig auf 'com.teccolino.hero8' geändert werden." >> "$TRANSITION_FILE"

# Hinweise für die nächste KI
echo "" >> "$TRANSITION_FILE"
echo "## Hinweise für die fortführende KI" >> "$TRANSITION_FILE"
echo "" >> "$TRANSITION_FILE"
echo "1. Nutze die vorhandene Projektstruktur und folge der Modulorganisation." >> "$TRANSITION_FILE"
echo "2. Teste regelmäßig nach signifikanten Änderungen." >> "$TRANSITION_FILE"
echo "3. Aktualisiere die Dokumentation mit dem 'update_docs.sh'-Skript." >> "$TRANSITION_FILE"
echo "4. Achte besonders auf Thread-Sicherheit bei der Asset-Verwaltung." >> "$TRANSITION_FILE"
echo "5. Nutze die Repository-Muster konsistent für den Datenzugriff." >> "$TRANSITION_FILE"

echo "${GREEN}Übergabedokumentation erfolgreich erstellt:${RESET} $TRANSITION_FILE"
