#!/bin/bash

# xc.sh - Extreme Kurzversion für Xcode-Extraktion
# Minimaler Befehl für Chat-Extraktion mit wenig Eingabeplatz
# WICHTIG: Dieses Skript ist für zeichenbegrenzte Situationen optimiert

mkdir -p /Users/ninaklee/Projects/hero8/ChatExtracts/$(date +%Y%m%d)

# Minimale Instruktion an die KI
echo "Folgende Nachricht in alten Chat kopieren:"
echo "./extract_xcode_info.sh extract"
echo "Oder noch kürzer:"
echo ". e"