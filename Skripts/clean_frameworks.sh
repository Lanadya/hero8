#!/bin/bash

# clean_frameworks.sh - Entfernt alle Framework-Rückstände aus dem Projekt

# Formatierung für bessere Lesbarkeit
BOLD=$(tput bold)
GREEN=$(tput setaf 2)
BLUE=$(tput setaf 4)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
RESET=$(tput sgr0)

echo "${BLUE}Räume alte Framework-Reste auf...${RESET}"

# In das Projektverzeichnis wechseln
cd /Users/ninaklee/Projects/hero8

# DerivedData für sauberen Build aufräumen
echo "${BLUE}Räume DerivedData auf...${RESET}"
rm -rf ~/Library/Developer/Xcode/DerivedData/*

# Xcodeproj-Einstellungen bereinigen
echo "${BLUE}Bereinige project.pbxproj...${RESET}"

# Build-Ordner aufräumen
echo "${BLUE}Räume Build-Ordner auf...${RESET}"
find . -name "build" -type d -exec rm -rf {} +

# Entferne xcuserdata um alte Schemas zu entfernen
echo "${BLUE}Räume xcuserdata auf...${RESET}"
find . -name "xcuserdata" -type d -exec rm -rf {} +

# Entferne Framework-Dateien, die versehentlich erstellt wurden
echo "${BLUE}Räume versehentlich erstellte Framework-Dateien auf...${RESET}"
find . -name "CoreDomain.framework" -exec rm -rf {} +
find . -name "CoreInfrastructure.framework" -exec rm -rf {} +
find . -name "HeroCoreData.framework" -exec rm -rf {} +

echo "${GREEN}Aufräumen abgeschlossen!${RESET}"
echo "${YELLOW}Wichtig: Schließen Sie Xcode komplett und öffnen Sie es neu.${RESET}"
