# Test-Push Anleitung

Bevor wir neue Inhalte zum xcode-reference Repository hinzufügen, müssen wir sicherstellen, dass der Push-Prozess funktioniert.

## Schritte zum Testen:

1. **Berechtigungen setzen**:
   ```bash
   cd /Users/ninaklee/Projects/hero8
   chmod +x fix_permissions.sh
   ./fix_permissions.sh
   ```

2. **Test-Push durchführen**:
   ```bash
   ./Scripts/test_xref_push.sh
   ```

3. **Ergebnis prüfen**:
   - Das Skript führt Sie durch den Test-Push
   - Es erstellt eine Test-Datei, pusht sie, und kann sie danach wieder entfernen
   - Prüfen Sie das Repository auf GitHub, ob der Test-Push erfolgreich war

4. **Bei Erfolg**:
   - Können wir mit dem Erstellen der neuen Dokumentationen fortfahren
   - Das System ist bereit für den Upload ins xcode-reference Repository

5. **Bei Problemen**:
   - Prüfen Sie die SSH-Verbindung zu GitHub
   - Kontrollieren Sie die Repository-URL: git@github.com:Lanadya/xcode-reference.git
   - Stellen Sie sicher, dass Sie Push-Berechtigungen haben

## Wichtig
- Das System verwendet einen Privacy-Filter, der sensible Daten automatisch entfernt
- Der Auto-Push ist auf "confirm" konfiguriert - Sie müssen die Änderungen bestätigen
- Alle Markdown-Dateien werden vor dem Push durchgescannt

Nach erfolgreichem Test können wir mit dem Hinzufügen der neuen Dokumentationen beginnen.
