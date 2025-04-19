# Xcode Reference - Schnellreferenz

## Was ist das?
Ein systematisches Archiv für Xcode-Dokumentation, Screenshots und Versionsinformationen.

## Schnellzugriff aus hero8

Alle Befehle können direkt aus dem hero8-Verzeichnis ausgeführt werden:

### Screenshot hinzufügen
```bash
./xcode-ref.sh add-screenshot <kategorie> <dateiname>
# Beispiel: ./xcode-ref.sh add-screenshot frameworks "target-dependencies.png"
```

### Dokumentation hinzufügen  
```bash
./xcode-ref.sh add-docs <pfad> <dateiname>
# Beispiel: ./xcode-ref.sh add-docs features "swiftui-5.0.md"
```

### Neue Xcode-Version einrichten
```bash
./xcode-ref.sh add-version <version>
# Beispiel: ./xcode-ref.sh add-version 16.7
```

### Status prüfen
```bash
./xcode-ref.sh status
```

### Änderungen zu GitHub pushen
```bash
./xcode-ref.sh push "Beschreibung der Änderungen"
```

## Verzeichnisstruktur

```
xcode-reference/
├── versions/
│   ├── 16.3/        (aktuelle Version)
│   │   ├── docs/
│   │   │   ├── features/
│   │   │   └── guides/
│   │   └── images/
│   │       ├── project-structure/
│   │       ├── build-settings/
│   │       └── frameworks/
│   └── [zukünftige Versionen]
├── common/          (versionübergreifende Ressourcen)
└── scripts/         (Automatisierung)
```

## Wichtige Hinweise

- Screenshots sollten aussagekräftige Namen haben
- Dokumentation im Markdown-Format erstellen
- Regelmäßig zu GitHub pushen
- Vor größeren Änderungen Status prüfen

## Backup-Repository

Falls das xcode-ref.sh Skript nicht funktioniert:
```bash
cd /Users/ninaklee/Projects/xcode-reference
git add .
git commit -m "Manuelle Aktualisierung"
git push
```
