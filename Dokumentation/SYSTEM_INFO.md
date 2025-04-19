# hero8 Systeminformationen
Stand: 2025-04-19

## Entwicklungsumgebung

### Xcode
- **Version**: 16.3 (16E140)
- **Letzte Aktualisierung**: Aktuell (April 2025)
- **Wichtige Features**: 
  - SwiftUI 5.0 Support
  - Swift 5.10 Compiler
  - Verbesserte Framework-Verwaltung

### macOS
- **Version**: Wird automatisch ermittelt
- **Kompatibilität**: Xcode 16.3 erfordert mindestens macOS 14.0

### Framework-Architektur
1. **CoreDomain** - Geschäftslogik und Domain-Modelle
2. **CoreInfrastructure** - Generische Infrastruktur
3. **HeroCoreData** - Core Data Persistenz

## Projekt-Konfiguration

### GitHub Repository
- URL: git@github.com:Lanadya/hero8.git
- Branch: main
- Remote: origin

### Automatisierung
- **Automatische Zwischenspeicherung**: Scripts/autosave_project.sh
- **KI-Übergabe**: Scripts/Documentation/prepare_ki_transition_updated.sh
- **Hauptskript**: hero8_run.sh

## Hinweise für KI-Sessions

1. **Kritisch**: Chat-Sessions können abrupt enden
2. **Wichtig**: Regelmäßige Zwischenspeicherung erforderlich
3. **Warnung**: Bereits existierende Dateien nicht überschreiben
4. **Vorsicht**: Bei Xcode-Referenzierung aufpassen
