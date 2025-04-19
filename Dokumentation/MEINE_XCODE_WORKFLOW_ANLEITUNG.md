# Meine Xcode-Workflow Anleitung

Stand: 2025-04-19

## A. Für alte Chat-Verläufe (wenn wenig Platz)

### Kürzester Befehl (nur 3 Zeichen):
```bash
./e
```

Falls das nicht geht, probieren Sie:
```bash
. e
```

Beide Befehle extrahieren automatisch alle Xcode-Infos aus dem Chat.
Das System verwendet textuelle Referenzen statt Bildverweise.

## B. Für aktuelle/neue Chat-Sessions

### 1. Während des Chats:
- Screenshot-Referenz erstellen:
  ```bash
  ./xcode-ref.sh create-screenshot-ref "Beschreibung"
  ```
- Feature markieren:
  ```bash
  ./xcode-ref.sh mark-feature "Feature" "Beschreibung"
  ```

### 2. Am Ende des Chats:
```bash
./Scripts/extract_xcode_info.sh finalize
./xcode-ref.sh process-session Dokumentation/XCODE_SESSION_[timestamp].md
```

## C. Manuelle Arbeit mit extrahierten Infos

### 1. Wo finde ich die Daten?
- Alte Chats: `/Users/ninaklee/Projects/hero8/ChatExtracts/[Datum]/`
- Neue Sessions: `/Users/ninaklee/Projects/hero8/Dokumentation/XCODE_SESSION_[timestamp].md`

### 1.1 WICHTIG: Datenüberprüfung
Vor der Übertragung ins Repository MÜSSEN Sie die extrahierten Daten prüfen:
1. Nach persönlichen Informationen suchen (E-Mails, Namen, IDs)
2. Strukturelle Integrität prüfen (Markdown-Format korrekt?)
3. Referenzen verifizieren (Screenshots, Links)
4. Inhaltliche Genauigkeit bestätigen (technisch korrekt?)

Detaillierte Anleitung: `EXTRACTION_VERIFICATION_GUIDE.md`
Praktische Beispiele: `EXTRACTION_VERIFICATION_EXAMPLE.md`

### 2. Wie übertrage ich sie ins Repository?
```bash
cd /Users/ninaklee/Projects/hero8

# Für Screenshots:
./xcode-ref.sh add-screenshot features "dateiname.png"

# Für Dokumentation:
./xcode-ref.sh add-docs features "dateiname.md"

# Änderungen pushen:
./xcode-ref.sh secure-push "Beschreibung der Änderungen"
```

## D. Auto-Push Status prüfen
```bash
./Scripts/secure_auto_push.sh status
```

## E. Wichtige Pfade zum Merken
- hero8: `/Users/ninaklee/Projects/hero8`
- xcode-reference: `/Users/ninaklee/Projects/xcode-reference`
- Extrakte: `/Users/ninaklee/Projects/hero8/ChatExtracts/`

## F. Bei Problemen
1. Prüfen Sie, ob Sie im richtigen Verzeichnis sind
2. Stellen Sie sicher, dass Skripte ausführbar sind
3. Schauen Sie in die `.filter_log` für Filterdetails
