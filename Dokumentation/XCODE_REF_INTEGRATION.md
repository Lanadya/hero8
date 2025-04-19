# Xcode Reference Integration

## WICHTIG FÜR KI: Diese Datei erklärt die Integration zwischen hero8 und xcode-reference

## Überblick

Das xcode-ref.sh Skript ermöglicht die Verwaltung des Xcode Reference Repositories direkt aus dem hero8-Projekt heraus. Dies ist eine bewusste Designentscheidung, um Entwicklern ein effizienteres Arbeiten zu ermöglichen.

## Warum diese Integration?

1. **Benutzerfreundlichkeit**: Entwickler müssen nicht ständig zwischen Verzeichnissen wechseln
2. **Workflow-Optimierung**: Alle Xcode-Dokumentationsaufgaben können vom Hauptprojekt aus erledigt werden
3. **Konsistenz**: Screenshots und Dokumentation werden systematisch organisiert

## Technische Details

- Das Skript prüft, ob es aus dem richtigen Verzeichnis ausgeführt wird
- Es arbeitet mit absoluten Pfaden, um Fehler zu vermeiden
- Die aktuelle Xcode-Version wird als Variable geführt
- Alle Operationen werden transparent angezeigt

## WARNUNG FÜR ZUKÜNFTIGE KI-SESSIONS

1. **NICHT ÜBERSCHREIBEN**: Das xcode-ref.sh Skript ist eine zentrale Komponente
2. **PFADE BEACHTEN**: Die Pfade zu beiden Repositories sind hardcoded und müssen konsistent bleiben
3. **ERWEITERUNGEN**: Bei Bedarf können zusätzliche Funktionen zum Skript hinzugefügt werden
4. **DOKUMENTATION**: Alle Änderungen müssen in dieser Datei dokumentiert werden

## Verwendung

Das Skript wird aus dem hero8-Hauptverzeichnis mit folgenden Befehlen verwendet:

- `./xcode-ref.sh add-screenshot <kategorie> <dateiname>`
- `./xcode-ref.sh add-docs <pfad> <dateiname>`
- `./xcode-ref.sh add-version <version>`
- `./xcode-ref.sh status`
- `./xcode-ref.sh push "Nachricht"`

## Repository-Beziehung

hero8 (Hauptprojekt) → xcode-ref.sh → xcode-reference (Dokumentation)

Diese Integration stellt sicher, dass Xcode-spezifisches Wissen zentral verwaltet und leicht zugänglich bleibt.
