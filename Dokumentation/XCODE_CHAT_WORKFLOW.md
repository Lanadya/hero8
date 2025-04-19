# Xcode Dokumentation im Chat-Workflow

## Neuer optimierter Prozess

Dieser Workflow ermöglicht es Ihnen, Xcode-Informationen direkt aus dem Chat-Kontext zu dokumentieren, ohne zusätzliche manuelle Schritte.

## Arbeitsablauf während einer KI-Session

### 1. Bei Bedarf Screenshot-Referenz erstellen

Wenn Sie einen Screenshot teilen möchten:
```bash
./xcode-ref.sh create-screenshot-ref "Build Settings Dialog"
```

Die KI gibt Ihnen dann eine Referenz wie `screenshot_2025-04-19_14-30-00`, die Sie im Chat verwenden können.

### 2. Wichtige Erkenntnisse markieren

Wenn Sie im Chat eine wichtige Erkenntnis über Xcode 16.3 teilen:
```bash
./xcode-ref.sh mark-feature "Neues SwiftUI Preview Feature" "In Xcode 16.3 kann man Live-Previews für SwiftUI Views direkt im Editor anzeigen lassen..."
```

### 3. Am Ende der Session zusammenfassen

Nach Abschluss der Chat-Session:
```bash
./Scripts/extract_xcode_info.sh finalize
```

Dies erstellt eine Session-Zusammenfassung mit allen markierten Informationen.

### 4. Session ins Referenz-Repository übernehmen

Um die Session ins xcode-reference Repository zu integrieren:
```bash
./xcode-ref.sh process-session Dokumentation/XCODE_SESSION_2025-04-19_14-30-00.md
```

### 5. Änderungen zu GitHub pushen

Abschließend:
```bash
./xcode-ref.sh push "Session 2025-04-19_14-30-00 hinzugefügt"
```

## Wie die KI damit arbeiten soll

1. **Screenshots**: Wenn Sie einen Screenshot zeigen, kann die KI eine Referenz dafür erstellen und diese im Chat verwenden.

2. **Features**: Wenn Sie neue Features oder Funktionen erklären, kann die KI diese direkt als Feature markieren.

3. **Probleme**: Bei Problemschilderungen kann die KI diese als Issues markieren.

4. **Zusammenfassung**: Am Ende jeder Session sollte die KI Sie daran erinnern, die Session zu finalisieren.

## Vorteile dieses Workflows

- Keine Unterbrechung Ihres natürlichen Chat-Flows
- Informationen werden dort erfasst, wo sie entstehen
- Einfache Nachbearbeitung und Archivierung
- Wiederverwendbarkeit für zukünftige KI-Sessions

## WICHTIG FÜR KI-SESSIONS

- Immer Referenzen für Screenshots erstellen
- Wichtige Erkenntnisse direkt markieren
- Am Ende auf Finalisierung hinweisen
- Keine manuellen Downloads oder Speicherungen nötig
