# Konkrete Beispiele zur Datenüberprüfung

## Beispiel 1: E-Mail-Adressen prüfen

Um E-Mail-Adressen zu finden, können Sie den grep-Befehl verwenden:

```bash
# Suche nach E-Mail-Patterns
grep -n "@" /Users/ninaklee/Projects/hero8/ChatExtracts/20250419_104315/*.md

# Oder spezifischer nach .com oder .de
grep -n -E "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}" *.md
```

Wenn Treffer gefunden werden, prüfen Sie, ob sie korrekt maskiert sind:
- `ninaklee@icloud.com` ❌ Nicht erlaubt
- `<email-removed>` ✅ Korrekt maskiert

## Beispiel 2: Namen überprüfen

Suchen Sie nach allen Wörtern mit Großbuchstaben, die Namen sein könnten:

```bash
# Finde Wörter die mit Großbuchstaben beginnen
grep -n -E '\b[A-Z][a-z]+\b' *.md
```

Anschließend prüfen Sie jeden Treffer manuell:
- `Nina Klee` ❌ Nicht erlaubt
- `<DEVELOPER_NAME>` ✅ Korrekt maskiert

## Beispiel 3: Bundle Identifier kontrollieren

Suchen Sie nach typischen Bundle-ID-Mustern:

```bash
# Suche nach com.* Patterns
grep -n -E "com\.[a-zA-Z0-9.]+" *.md
```

Verifizieren Sie, dass persönliche/unternehmensspezifische IDs ersetzt wurden:
- `com.teccolino.HeroCoreDataTests` ❌ Enthält persönliche Domain
- `com.example.HeroCoreDataTests` ✅ Generische Beispieldomain

## Beispiel 4: Strukturelle Prüfung

Verwenden Sie Markdown-Linting-Tools oder prüfen Sie manuell:

```bash
# Prüfe Markdown-Struktur (falls mdl installiert)
mdl screenshots.md
```

Manuell zu prüfen:
- Sind alle Überschriften korrekt formatiert (`#`, `##`, etc.)?
- Sind Code-Blöcke richtig markiert (mit Backticks)?
- Sind Listen richtig formatiert?

## Beispiel 5: Inhaltliche Konsistenz

Vergleichen Sie extrahierte Referenzen mit den Originalen:

```bash
# Finde alle Screenshot-Referenzen
grep -n -E "\[screenshot_[0-9-_]+\]" *.md
```

Prüfen Sie:
- Hat jede Referenz eine zugehörige Beschreibung?
- Stimmen die Zeitstempel mit dem Chat-Verlauf überein?
- Sind die Beschreibungen technisch korrekt?

## Beispiel 6: Dateivergleich mit diff

Nachdem Sie Korrekturen vorgenommen haben:

```bash
# Vergleiche Original und korrigierte Version
diff -u original.md corrected.md
```

Dies zeigt Ihnen genau, welche Änderungen gemacht wurden.

## Automatisierter Quick-Check

Hier ist ein Bash-Skript für eine schnelle Basisprüfung:

```bash
#!/bin/bash
EXTRACT_DIR="/Users/ninaklee/Projects/hero8/ChatExtracts/20250419_104315"

echo "Suche nach potentiellen E-Mail-Adressen..."
grep -n "@" "$EXTRACT_DIR"/*.md

echo "Suche nach Namen (Großbuchstaben-Wörter)..."
grep -n -E '\b[A-Z][a-z]+\s+[A-Z][a-z]+\b' "$EXTRACT_DIR"/*.md

echo "Suche nach Bundle Identifiern..."
grep -n -E "com\.[a-zA-Z0-9.]+" "$EXTRACT_DIR"/*.md

echo "Suche nach unvollständigen Maskierungen..."
grep -n -E "\([A-Z]+\.\.\." "$EXTRACT_DIR"/*.md
```

Speichern Sie dies als `quick_check.sh` und führen Sie es aus, um eine erste Übersicht zu erhalten.
