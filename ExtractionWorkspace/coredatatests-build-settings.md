# HeroCoreDataTests Build Settings in Xcode 16.3

## Übersicht
Detaillierte Dokumentation der Build Settings für das HeroCoreDataTests Target in einem Swift-Projekt. Diese Einstellungen zeigen die typische Konfiguration für Test-Targets in Xcode 16.3.

## Architektur-Einstellungen

### Architectures
- **Standard Architectures (Apple Silicon, Intel)**: $(ARCHS_STANDARD)
  - Dies nutzt die Standard-Architekturen für die Zielplattform
  - Wichtig für Universal Binary Support auf Apple Silicon und Intel Macs

### Build Active Architecture Only
- **Debug**: Yes
- **Release**: No
- Diese Einstellung beschleunigt Debug-Builds, während Release-Builds alle Architekturen enthalten

### Supported Platforms
- **iOS macOS visionOS**
- Das Test-Target unterstützt alle drei Apple-Plattformen

## Asset-Verwaltung

### Asset Pack Manifest URL Prefix
- Keine Konfiguration

### Embed Asset Packs In Product Bundle
- **No**
- Standard für Test-Targets

### Enable On Demand Resources
- **No**
- Auf Test-Targets nicht relevant

## Build Locations

### Build Products Path
- **build**
- Standard-Verzeichnis für Build-Produkte

### Intermediate Build Files Path
- **build**
- Gleicher Pfad wie Build Products für einfachere Verwaltung

### Precompiled Headers Cache Path
- **build/SharedPrecompiledHeaders**
- Standardpfad für optimierte Build-Performance

## Build Options

### Allow Multi-Platform Builds
- **Yes**
- Ermöglicht das Bauen für mehrere Plattformen gleichzeitig

### Always Embed Swift Standard Libraries
- **No** - $(EMBEDDED_CONTENT_CONTAINS_SWIFT)
- Dynamic: Hängt von der Variable ab, ob Swift-Libraries eingebettet werden

### Build Libraries for Distribution
- **No**
- Nicht erforderlich für Test-Targets

### Build Variants
- **normal**
- Standard-Build-Variante

### Compiler for C/C++/Objective-C
- **Default compiler (Apple Clang)**
- Verwendet den Standard Apple Clang Compiler

### Debug Information Format
- **Debug**: DWARF
- **Release**: DWARF with dSYM File
- Optimiert für Debug-Erfahrung vs. Release-Distribution

### Debug Information Version
- **Compiler Default**

### Eager Linking
- **No**

### Enable Code Coverage Support
- **Yes**
- Wichtig für Test-Targets zur Code-Coverage-Analyse

### Enable Debug Dylib Support
- **No**

### Enable Index-While-Building Functionality
- **Default**

### Enable Testability
- **Debug**: Yes
- **Release**: No
- Aktiviert spezielle Test-Funktionen im Debug-Modus

## Besonderheiten für Test-Targets

1. **Code Coverage**: Explizit aktiviert für Testauswertung
2. **Testability**: Nur im Debug-Modus aktiviert
3. **Multi-Platform Support**: Ermöglicht Tests auf verschiedenen Plattformen
4. **Optimierte Debug-Builds**: Nur aktive Architektur im Debug-Modus

## Referenzierter Screenshot
[screenshot_2025-04-19_14-30-00]

## Gefunden in Chat
2025-04-19 - Xcode-Reference Testing
