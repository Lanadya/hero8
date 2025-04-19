#!/bin/bash

# prepare_ki_transition.sh
# Alternative für KI-Übergabe für hero8
# Angelegt am: 2025-04-19

# Dieses Skript leitet einfach weiter zum aktualisierten Skript
PROJECT_ROOT="/Users/ninaklee/Projects/hero8"
SCRIPT_PATH="$PROJECT_ROOT/Scripts/Documentation/prepare_ki_transition_updated.sh"

# Prüfe ob das aktualisierte Skript existiert
if [ -f "$SCRIPT_PATH" ]; then
    chmod +x "$SCRIPT_PATH"
    exec "$SCRIPT_PATH"
else
    echo "Fehler: Das aktualisierte Übergabeskript wurde nicht gefunden."
    echo "Erwarteter Pfad: $SCRIPT_PATH"
    exit 1
fi