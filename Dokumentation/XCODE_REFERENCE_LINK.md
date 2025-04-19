# Xcode Version Reference

## Aktuelle Version
- Xcode 16.3 (16E140)
- macOS 15.4

## Referenz-Repository

Für detaillierte Informationen zur verwendeten Xcode-Version siehe das separate Referenz-Repository:

**Repository**: git@github.com:Lanadya/xcode-reference.git
(Jetzt auf GitHub verfügbar)

### Verwendung

1. Navigieren Sie zu `versions/16.3/` im Referenz-Repository
2. Finden Sie Screenshots unter `images/`
3. Lesen Sie Anleitungen unter `docs/guides/`
4. Prüfen Sie spezifische Features unter `docs/features/`

### Warum ein separates Repository?

- Versionierbarkeit: Unterstützt mehrere Xcode-Versionen parallel
- Wiederverwendbarkeit: Kann für alle Projekte genutzt werden
- Wartbarkeit: Zentral verwaltete Xcode-Dokumentation
- Zukunftssicher: Einfaches Hinzufügen neuer Versionen

Wenn Sie später z.B. Xcode 16.7 dokumentieren möchten, führen Sie einfach aus:
```
cd /Users/ninaklee/Projects/xcode-reference/scripts
./add_version.sh 16.7
```
