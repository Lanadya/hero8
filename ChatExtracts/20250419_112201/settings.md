# Build Settings und Konfigurationen in Xcode 16.3

## Architecture Settings

### Standard Architectures
- $(ARCHS_STANDARD) für Apple Silicon und Intel
- Universal Binary Support
- Automatische Architekturauswahl basierend auf Zielgerät

### Build Active Architecture Only
- Debug: Yes - Beschleunigt Entwicklungszyklus
- Release: No - Erstellt vollständige Builds
- Optimiert Build-Zeit während der Entwicklung

## Platform Support

- iOS, macOS, visionOS Unterstützung
- Einheitliche Konfiguration über Plattformen hinweg
- Automatische Anpassung an Plattform-Spezifika

## Asset Management

### Asset Pack Konfiguration
- Manifest URL Prefix: nicht gesetzt
- Embed Asset Packs: No (Standard für Test-Targets)
- On Demand Resources: No

## Build Locations

- Build Products Path: build
- Intermediate Build Files Path: build
- Precompiled Headers Cache Path: build/SharedPrecompiledHeaders
- Standardkonfiguration für einfaches Projektmanagement

## Build Options für Test-Targets

### Debug Configuration
- Enable Code Coverage Support: Yes
- Enable Testability: Yes
- Debug Information Format: DWARF

### Release Configuration
- Enable Code Coverage Support: Yes
- Enable Testability: No
- Debug Information Format: DWARF with dSYM File

## Signing & Capabilities

### Automatic Signing
- Automatically manage signing: Aktiviert
- Vereinfachte Zertifikatsverwaltung
- Automatische Provisioning Profile Erstellung

### Team und Identität
- Team ID: maskiert aus Datenschutzgründen
- Bundle Identifier: com.example (generisch)
- Signing Certificate: Development (ohne Provisioning Profile)
