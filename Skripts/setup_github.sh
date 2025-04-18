#!/bin/bash

# setup_github.sh - Richtet GitHub-Repository ein und pusht den aktuellen Stand

# Formatierung für bessere Lesbarkeit
BOLD=$(tput bold)
GREEN=$(tput setaf 2)
BLUE=$(tput setaf 4)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
RESET=$(tput sgr0)

echo "${BLUE}Konfiguriere das GitHub-Repository als Remote...${RESET}"

# In das Projektverzeichnis wechseln
cd /Users/ninaklee/Projects/hero8

# Prüfen, ob ein Remote bereits existiert
if git remote -v | grep -q "origin"; then
    echo "${YELLOW}Ein Remote namens 'origin' existiert bereits. Wird entfernt...${RESET}"
    git remote remove origin
fi

# Remote hinzufügen
git remote add origin git@github.com:Lanadya/hero8.git

# Änderungen hinzufügen
echo "${BLUE}Füge alle Änderungen zum Git-Repository hinzu...${RESET}"
git add .

# Commit erstellen
echo "${BLUE}Erstelle einen initialen Commit...${RESET}"
git commit -m "Initialer Commit: Migration von hero6-Komponenten zu hero8"

# Push durchführen
echo "${BLUE}Pushe Änderungen zum GitHub-Repository...${RESET}"
git push -u origin main

echo "${GREEN}GitHub-Repository wurde erfolgreich eingerichtet und alle Änderungen wurden gesichert!${RESET}"
