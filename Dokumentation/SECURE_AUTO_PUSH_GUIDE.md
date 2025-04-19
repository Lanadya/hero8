# Sicherer Auto-Push für Xcode Reference

## Überblick

Diese Anleitung erklärt das neue System für automatisches Git-Push mit integriertem Datenschutz. Es kombiniert die Effizienz automatischer Pushes mit dem Schutz persönlicher Informationen.

## Wie funktioniert das System?

### 1. Privacy Filter

Das System verwendet einen intelligenten Filter, der automatisch persönliche Informationen erkennt und maskiert:
- Benutzernamen in Dateipfaden (`/Users/ninaklee/` → `/Users/<USER>/`)
- E-Mail-Adressen
- API-Keys und Tokens
- Git-Repository-URLs
- Passwörter

### 2. Auto-Push-Modi

Sie können zwischen drei Modi wählen:
1. **Vollautomatisch**: Gefilterte Daten werden automatisch ersetzt und gepusht
2. **Mit Bestätigung**: Sie überprüfen die Filterung vor dem Push
3. **Deaktiviert**: Manueller Push erforderlich

### 3. Integration in den Workflow

Der Auto-Push ist nahtlos in den bestehenden Workflow integriert:
- Nach jeder Session-Verarbeitung kann automatisch gepusht werden
- Filterung erfolgt transparent vor dem Push
- Alle Änderungen werden protokolliert

## Einrichtung und Konfiguration

### Erstmalige Konfiguration

```bash
./xcode-ref.sh configure-auto-push
```

Sie werden dann nach Ihrem bevorzugten Modus gefragt.

### Status prüfen

```bash
./Scripts/secure_auto_push.sh status
```

## Verwendung im täglichen Workflow

### Automatisches Pushen nach Session-Verarbeitung

Wenn Sie den Auto-Push aktiviert haben, geschieht der Push automatisch nach:
```bash
./xcode-ref.sh process-session Dokumentation/XCODE_SESSION_2025-04-19_14-30-00.md
```

### Manueller sicherer Push

Für manuelles Pushen mit Datenschutzfilter:
```bash
./xcode-ref.sh secure-push "Ihre Commit-Nachricht"
```

## Sicherheitsfeatures

### Was wird gefiltert?

1. **Pfade**: Alle persönlichen Verzeichnisse werden anonymisiert
2. **Zugangsdaten**: API-Keys, Tokens, Passwörter werden entfernt
3. **Persönliche Identifikatoren**: E-Mail-Adressen, Benutzernamen
4. **Sensible URLs**: Git-Repository-URLs mit persönlichen Daten

### Filter-Log

Alle Filteroperationen werden protokolliert in:
```
/Users/ninaklee/Projects/hero8/.filter_log
```

## Wichtige Hinweise

- Der Filter arbeitet nur mit Markdown-Dateien
- Binärdateien (Screenshots, etc.) werden nicht gefiltert
- Bei Unsicherheit wählen Sie den Modus "Mit Bestätigung"
- Regelmäßig das Filter-Log überprüfen

## Konfigurationsdatei

Die Auto-Push-Einstellungen werden gespeichert in:
```
/Users/ninaklee/Projects/hero8/.auto_push_config
```

Diese Datei enthält:
- `AUTO_MODE`: full, confirm oder disabled
- `AUTO_APPROVE`: true oder false

## Troubleshooting

### Push wird abgebrochen

Wenn der Push aufgrund sensibler Daten abgebrochen wird:
1. Überprüfen Sie die gefundenen Probleme im Filter-Log
2. Entscheiden Sie, ob die gefilterte Version akzeptabel ist
3. Führen Sie den Push erneut aus

### Filter zu aggressiv

Falls der Filter zu viele Daten entfernt:
1. Überprüfen Sie die Filterregeln in `privacy_filter.sh`
2. Passen Sie die Regeln an Ihre Bedürfnisse an
3. Testen Sie mit dem Verbose-Modus

## Zukünftige Erweiterungen

- Anpassbare Filterregeln per Konfigurationsdatei
- Whitelist für bestimmte Pfade oder Muster
- Integration mit anderen Git-Workflows