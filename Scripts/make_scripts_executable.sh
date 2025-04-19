#!/bin/bash

# Macht alle Skripte im Scripts-Verzeichnis ausführbar

SCRIPT_DIR="/Users/ninaklee/Projects/hero8/Scripts"

# Mache dieses Skript selbst ausführbar
chmod +x "$SCRIPT_DIR/make_scripts_executable.sh"

# Mache alle anderen Skripte ausführbar
chmod +x "$SCRIPT_DIR"/*.sh

echo "Alle Skripte in $SCRIPT_DIR sind nun ausführbar"

# Spezifische Skripte prüfen
echo "Status der wichtigsten Skripte:"
ls -la "$SCRIPT_DIR"/secure_auto_push.sh
ls -la "$SCRIPT_DIR"/check_xref_status.sh
ls -la "$SCRIPT_DIR"/extract_xcode_info.sh
