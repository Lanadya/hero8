#!/bin/bash

# fix_entitlements.sh - Korrigiert das Problem mit Entitlements im Projekt

# Formatierung für bessere Lesbarkeit
BOLD=$(tput bold)
GREEN=$(tput setaf 2)
BLUE=$(tput setaf 4)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
RESET=$(tput sgr0)

echo "${BLUE}Korrigiere Entitlements-Problem...${RESET}"

# In das Projektverzeichnis wechseln
cd /Users/ninaklee/Projects/hero8

# Stelle sicher, dass das Entitlements-File im richtigen Verzeichnis ist
if [ -f "App/hero8.entitlements" ]; then
    echo "${BLUE}Kopiere Entitlements-File in das hero8-Verzeichnis...${RESET}"
    cp App/hero8.entitlements hero8/
    echo "${GREEN}Entitlements-File wurde kopiert.${RESET}"
else
    echo "${RED}Entitlements-File nicht gefunden!${RESET}"
    exit 1
fi

echo "${GREEN}Entitlements-Problem wurde behoben!${RESET}"
