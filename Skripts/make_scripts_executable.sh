#!/bin/bash

# make_scripts_executable.sh - Setzt alle Skripts auf ausführbar

# Formatierung für bessere Lesbarkeit
BOLD=$(tput bold)
GREEN=$(tput setaf 2)
BLUE=$(tput setaf 4)
RESET=$(tput sgr0)

echo "${BLUE}Setze alle Skripts auf ausführbar...${RESET}"

# Alle .sh-Dateien im aktuellen Verzeichnis auf ausführbar setzen
chmod +x ./*.sh

echo "${GREEN}Alle Skripts erfolgreich auf ausführbar gesetzt!${RESET}"
