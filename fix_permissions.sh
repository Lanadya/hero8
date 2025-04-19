#!/bin/bash

# fix_permissions.sh - Setzt alle notwendigen Berechtigungen

# Mache dieses Skript selbst ausführbar
chmod +x "$0"

# Setze Berechtigungen für hero8-Skripte
chmod +x /Users/ninaklee/Projects/hero8/xcode-ref.sh
chmod +x /Users/ninaklee/Projects/hero8/e
chmod +x /Users/ninaklee/Projects/hero8/generate_uebergabe.sh

# Setze Berechtigungen für alle Skripte im Scripts-Verzeichnis
chmod +x /Users/ninaklee/Projects/hero8/Scripts/*.sh

echo "Alle Berechtigungen wurden gesetzt."
echo ""
echo "Wichtigste Skripte:"
ls -la /Users/ninaklee/Projects/hero8/xcode-ref.sh
ls -la /Users/ninaklee/Projects/hero8/Scripts/secure_auto_push.sh
ls -la /Users/ninaklee/Projects/hero8/Scripts/test_xref_push.sh

echo ""
echo "Sie können jetzt den Test-Push mit folgendem Befehl durchführen:"
echo "./Scripts/test_xref_push.sh"
