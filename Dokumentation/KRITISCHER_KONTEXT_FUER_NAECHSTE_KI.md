# Kritischer Kontext für nächste KI-Session

## WICHTIGSTE ENTWICKLUNGEN

### 1. Xcode-Reference-System eingerichtet
- Git-Repository: git@github.com:Lanadya/xcode-reference.git (öffentlich)
- Versionierbare Struktur für Xcode-Dokumentation
- Aktuell: Xcode 16.3 (16E140)

### 2. Automated Chat-Extraktion
- Script `e` (nur 1 Buchstabe!) für alte Chats mit begrenztem Eingabeplatz
- Befehl: `./e` oder `. e` (falls zeichenbegrenzt)
- Automatische Extraktion von Screenshots, Features, Settings, Issues

### 3. Secure Auto-Push
- Konfiguriert mit Option 2 (mit Bestätigung)
- Filtert automatisch persönliche Informationen
- privacy_filter.sh entfernt sensible Daten vor dem Push

### 4. hero8-Integration
- Zentrale Steuerung über xcode-ref.sh
- Live-Markierung während Chat-Sessions
- Automatische Session-Zusammenfassungen

### 5. MCP-Fähigkeiten dieser KI
Die KI KANN direkt:
- Dateien lesen/schreiben (read_file, write_file)
- Verzeichnisse erstellen (create_directory)
- Xcode/Simulator steuern
- Git-Operationen simulieren

### 6. Workflow-System
- Alte Chats: Minimalbefehl `./e` für Komplett-Extraktion
- Neue Chats: Live-Markierung und Session-Finalisierung
- Auto-Push: Sicheres Pushen mit Privacy-Filter

### 7. Wichtige Pfade
- hero8: `/Users/ninaklee/Projects/hero8`
- xcode-reference: `/Users/ninaklee/Projects/xcode-reference`
- Extrakte: `/Users/ninaklee/Projects/hero8/ChatExtracts/`

## WICHTIG FÜR NÄCHSTE KI

1. Diese KI hat eine umfassende Infrastruktur aufgebaut
2. Nicht neu installieren oder überschreiben
3. Bestehende Skripte nutzen und erweitern
4. Privacy-Filter respektieren und beibehalten
5. Auto-Push ist auf "mit Bestätigung" konfiguriert

## OFFENE AUFGABEN

1. Alte Chat-Verläufe mit `./e` extrahieren
2. Extrahierte Daten ins xcode-reference übertragen
3. Repository mit Community-Beiträgen erweitern
4. Framework-Integration in Xcode abschließen

## SPEZIALWISSEN

- Xcode 16.3 (16E140) wird verwendet
- macOS 15.4 ist die Entwicklungsumgebung
- Das System ist für Europa ohne Internetzugang optimiert
- Screenshots werden über Referenz-System verwaltet
