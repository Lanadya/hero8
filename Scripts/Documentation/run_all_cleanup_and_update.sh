#!/bin/bash

# Master-Skript zum Ausführen aller Aufräum- und Update-Aktionen
# Erstellt am: 2025-04-19

echo "🔄 Starte vollständigen Aufräum- und Update-Prozess..."
echo ""

# 1. Backup-Dateien aufräumen und Roadmap korrigieren
echo "1️⃣ Führe Aufräumarbeiten durch..."
./Scripts/Documentation/cleanup_xcode_reference.sh
echo ""

# 2. Neue Struktur commiten und pushen
echo "2️⃣ Update Strukturänderungen..."
./Scripts/Documentation/update_xcode_reference_structure_and_return.sh
echo ""

# 3. hero8 Dokumentation vorbereiten
echo "3️⃣ Bereite KI-Übergabe vor..."
./Scripts/Documentation/prepare_ki_transition_updated.sh
echo ""

# 4. hero8 Änderungen sichern
echo "4️⃣ Sichere hero8 Änderungen..."
./hero8_run.sh push_changes "KI-Wechsel: Sichern aller Änderungen und Aufräumarbeiten"
echo ""

echo "✅ Alle Aufräum- und Update-Aktionen abgeschlossen!"
echo ""
echo "Übersicht der durchgeführten Aktionen:"
echo "- xcode-reference: Backup-Dateien entfernt"
echo "- xcode-reference: Roadmap realistisch angepasst"
echo "- xcode-reference: Neue Dokumentationsstruktur erstellt"
echo "- hero8: KI-Übergabedokumentation aktualisiert"
echo "- Alle Änderungen gesichert und gepusht"
