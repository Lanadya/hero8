# hero8

## Übersicht

hero8 ist eine Bildungsanwendung für iOS, die Lehrern hilft, ihre Klassen, Schüler und Bewertungen zu verwalten. 
Diese App ist eine Neuimplementierung von hero6, mit besonderem Fokus auf Thread-Sicherheit und modulare Architektur.

## Projektstruktur

- **App**: Hauptapp-Dateien und Einstiegspunkt
- **Core**: Kernfunktionalitäten wie ThreadSafeAssetManager
- **CoreDomain**: Domänenmodelle und Repository-Protokolle
- **CoreInfrastructure**: Repository-Implementierungen
- **Features**: Feature-Module (UI, ViewModels)
- **HeroCoreData**: Core Data Modell und Entity-Klassen
- **Dokumentation**: Projektdokumentation
- **Skripts**: Hilfsskripte für Entwicklung und Wartung

## Schlüsselkonzepte

### Thread-Sicherheit

hero8 verwendet einen ThreadSafeAssetManager, um CUICatalog-Fehler zu vermeiden, die in hero6 auftraten.
Dieser Manager stellt sicher, dass alle Asset-Zugriffe (Bilder, Farben) thread-sicher erfolgen.

Beispiel für den sicheren Asset-Zugriff in SwiftUI:
```swift
// Sicherer Farb-Zugriff
Text("Beispiel")
    .foregroundColor(Color.safe("accentColor"))

// Sicherer Bild-Zugriff
Image.safe("starIcon")
```

### Modulare Architektur

Die App folgt einer klaren modularen Struktur mit separation of concerns:

```
app
 ├── CoreDomain (Domänenmodelle, Protokolle)
 ├── CoreInfrastructure (Repository-Implementierungen, abhängig von CoreDomain)
 ├── HeroCoreData (Core Data Entitäten, abhängig von CoreDomain) 
 └── Features (UI-Komponenten, abhängig von allen anderen Modulen)
```

### Repository-Pattern

Alle Datenzugriffe erfolgen über das Repository-Pattern, mit klaren Schnittstellen (Protokollen) in CoreDomain
und Implementierungen in CoreInfrastructure.

## Entwicklungsskripts

Im Verzeichnis `Skripts` befinden sich hilfreiche Skripts für die Entwicklung:

- `update_docs.sh`: Aktualisiert die Dokumentation mit dem aktuellen Migrationsstand
- `prepare_ki_transition.sh`: Erstellt eine Übergabedokumentation für KI-Wechsel
- `push_changes.sh`: Sichert Änderungen und erstellt Backups
- `make_scripts_executable.sh`: Setzt alle Skripts auf ausführbar

## Migration von hero6

hero8 ist eine Neuimplementierung von hero6 mit folgenden Verbesserungen:

1. Thread-sichere Asset-Verwaltung
2. Klare modulare Struktur
3. Vollständige Repository-Pattern Implementierung
4. Präzise Fehlerverwaltung

Die vollständige Migrationsdokumentation findet sich in `Dokumentation/MIGRATIONSSTAND.md`.

## Entwicklungsrichtlinien

1. Alle Asset-Zugriffe müssen über den ThreadSafeAssetManager erfolgen
2. Neue Features sollten in eigenen Feature-Modulen implementiert werden
3. Datenzugriff ausschließlich über Repository-Pattern
4. Regelmäßiges Testen nach größeren Änderungen
5. Dokumentation aktualisieren mit update_docs.sh
