# Build Settings für Test-Targets in Xcode 16.3

## Architecture Settings

### Architectures
- **Standard**: $(ARCHS_STANDARD)
- **Bedeutung**: Unterstützt sowohl Apple Silicon als auch Intel-Architekturen
- **Best Practice**: Verwenden Sie die Standard-Einstellung für maximale Kompatibilität

### Build Active Architecture Only
- **Debug**: Yes
- **Release**: No
- **Bedeutung**: Beschleunigt Debug-Builds erheblich durch Fokus auf aktive Architektur
- **Best Practice**: Behalten Sie diese Einstellung für schnellere Entwicklungszyklen

### Supported Platforms
- **Konfiguration**: iOS macOS visionOS
- **Bedeutung**: Test-Target unterstützt alle drei Apple-Plattformen
- **Best Practice**: Wichtig für Cross-Platform-Tests

## Asset Management

### Asset Pack Configuration
- **Manifest URL Prefix**: Nicht gesetzt
- **Embed Asset Packs**: No
- **On Demand Resources**: No
- **Best Practice**: Für Test-Targets meist keine Asset-Konfiguration erforderlich

## Build Locations

### Paths
- **Build Products Path**: build
- **Intermediate Build Files Path**: build
- **Precompiled Headers Cache Path**: build/SharedPrecompiledHeaders
- **Best Practice**: Standard-Pfade verwenden für einfachere Projektverwaltung

## Build Options

### Multi-Platform Builds
- **Allow Multi-Platform Builds**: Yes
- **Bedeutung**: Ermöglicht gleichzeitiges Bauen für mehrere Plattformen

### Swift Library Embedding
- **Always Embed Swift Standard Libraries**: No - $(EMBEDDED_CONTENT_CONTAINS_SWIFT)
- **Bedeutung**: Dynamisch basierend auf Swift-Nutzung
- **Best Practice**: Automatische Erkennung nutzen

### Build Libraries for Distribution
- **Setting**: No
- **Bedeutung**: Nicht erforderlich für Test-Targets

### Compiler Settings
- **Compiler for C/C++/Objective-C**: Default compiler (Apple Clang)
- **Build Variants**: normal

### Debug Configuration
- **Debug Information Format**: 
  - Debug: DWARF
  - Release: DWARF with dSYM File
- **Debug Information Version**: Compiler Default
- **Eager Linking**: No

### Testing Features
- **Enable Code Coverage Support**: Yes
- **Enable Testability**: 
  - Debug: Yes
  - Release: No
- **Best Practice**: Aktivieren Sie Code Coverage für Test-Auswertung

## Signing & Capabilities

### Automatic Signing
- **Automatically manage signing**: Aktiviert
- **Bedeutung**: Xcode verwaltet automatisch Profile und Zertifikate
- **Best Practice**: Empfohlen für einfachere Entwicklung

### Team Configuration
- **Team**: <DEVELOPER_NAME> (Personal Team)
- **Bundle Identifier**: com.example.HeroCoreDataTests
- **Best Practice**: Verwenden Sie konsistente Bundle IDs für Test-Targets

### Platform-spezifische Einstellungen
- **iOS/macOS/visionOS**: 
  - Provisioning Profile: None Required
  - Signing Certificate: Development/<ID-removed>
- **Best Practice**: Test-Targets benötigen keine spezifischen Provisioning Profiles

## Empfehlungen für Test-Targets

1. **Performance-Optimierung**: Aktivieren Sie "Build Active Architecture Only" für Debug
2. **Code-Qualität**: Nutzen Sie Code Coverage Support
3. **Signing-Vereinfachung**: Verwenden Sie automatische Signing-Verwaltung
4. **Multi-Platform**: Aktivieren Sie Unterstützung für alle relevanten Plattformen
5. **Debug-Erfahrung**: Optimieren Sie Debug Information Format basierend auf Build-Konfiguration
