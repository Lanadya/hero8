#!/bin/bash

# commit_framework_creation.sh - Commitet die Framework-Erstellung

# Formatierung für bessere Lesbarkeit
BOLD=$(tput bold)
GREEN=$(tput setaf 2)
BLUE=$(tput setaf 4)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
RESET=$(tput sgr0)

echo "${BLUE}Committe Framework-Erstellung...${RESET}"

# In das Projektverzeichnis wechseln
cd /Users/ninaklee/Projects/hero8

# Änderungen hinzufügen
git add hero8.xcodeproj
git add .

# Commit erstellen
git commit -m "Frameworks CoreDomain, CoreInfrastructure und HeroCoreData hinzugefügt"

# Push zu GitHub
git push

echo "${GREEN}Framework-Erstellung wurde committet und gepusht!${RESET}"
