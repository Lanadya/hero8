# Probleme und Lösungen für Xcode 16.3

## 1. GitHub "Invalid image source" Fehler

**Problem**: GitHub zeigt Fehlermeldungen, wenn Markdown-Dateien Verweise auf nicht existierende Bilder enthalten.

**Lösung**: Verwendung von textuellen Referenzen statt Bild-Links:
- Statt `![Bild](pfad)` verwenden: `**Referenz**: [Beschreibung]`
- Automatisierte Konvertierung durch spezielle Skripte
- Dokumentation bleibt informativ ohne irreführende Bildverweise

**Referenz**: [issue_invalid-image-source]

## 2. Privacy-Filter für sensible Daten

**Problem**: Screenshots und Dokumentation enthalten persönliche Informationen wie E-Mail-Adressen, Namen und Entwickler-IDs.

**Lösung**: Automatischer Privacy-Filter:
- E-Mail-Adressen werden zu `<email-removed>`
- Namen werden zu `<DEVELOPER_NAME>`
- Bundle Identifier werden zu `com.example.*`
- Apple Developer IDs werden zu `(<ID-removed>)`

**Referenz**: [issue_privacy-filter]

## 3. Terminal-Befehlprobleme mit Anführungszeichen

**Problem**: Echo-Befehle mit dynamischem Datum scheitern aufgrund von Anführungszeichen-Parsing-Problemen.

**Lösung**: Verwendung von einfachen Anführungszeichen oder `printf`:
- Statt `echo "Text mit $datum"` verwenden: `echo 'Text mit festen Datum'`
- Alternative: `printf 'Text\n' >> datei.md`

**Referenz**: [issue_terminal-commands]

## 4. Chat-basierte Extraktion in zeichenbegrenzten Umgebungen

**Problem**: Alte Chats haben Zeichenlimit, was komplexe Befehle unmöglich macht.

**Lösung**: Entwicklung eines Minimalbefehls `./e`:
- Nur 3 Zeichen für vollständige Extraktion
- Automatische Erkennung und Verarbeitung durch KI
- Strukturierte Ausgabe in Markdown-Format

**Referenz**: [issue_chat-extraction]

## 5. Referenzen auf nicht existierende Screenshots

**Problem**: KI kann Screenshots im Chat sehen, aber nicht als Dateien extrahieren.

**Lösung**: Systematisches Referenzsystem:
- Eindeutige Screenshot-IDs mit Zeitstempel
- Dokumentation besteht auch ohne Bilddateien
- Manuelle Screenshot-Integration wenn nötig

**Referenz**: [issue_screenshot-references]
