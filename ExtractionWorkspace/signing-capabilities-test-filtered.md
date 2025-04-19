# Signing & Capabilities für Test-Targets in Xcode 16.3

## Übersicht
Dokumentation der Signing & Capabilities Einstellungen für ein Test-Target (HeroCoreDataTests) in Xcode 16.3. Diese Einstellungen zeigen die typische Konfiguration für Unit-Test-Targets in Swift-Projekten.

## Signing-Konfiguration

### Allgemeine Einstellungen
- **Automatically manage signing**: Aktiviert
  - Xcode erstellt und aktualisiert automatisch Profile, App IDs und Zertifikate
  - Empfohlen für einfachere Entwicklung und Vermeidung manueller Konfigurations-Fehler

### Team-Konfiguration
- **Team**: <DEVELOPER_NAME> (Personal Team)
  - Persönliche oder Organisations-Team-ID für App-Signierung
  - Für Test-Targets meist dasselbe Team wie Haupt-App

### Bundle Identifier
- **Wert**: com.example.HeroCoreDataTests
  - Eindeutige ID für das Test-Target
  - Konvention: [hauptapp-bundle]Tests

## Platform-spezifische Einstellungen

### iOS
- **Bundle Identifier**: com.example.HeroCoreDataTests
- **Provisioning Profile**: None Required (für Tests)
- **Signing Certificate**: Apple Development: <email-removed> (<ID-removed>)

### macOS
- **Bundle Identifier**: com.example.HeroCoreDataTests
- **Provisioning Profile**: None Required (für Tests)
- **Signing Certificate**: Development

### visionOS
- **Bundle Identifier**: com.example.HeroCoreDataTests
- **Provisioning Profile**: None Required (für Tests)
- **Signing Certificate**: Apple Development: <email-removed> (<ID-removed>)

## Besonderheiten für Test-Targets

1. **Keine Provisioning Profiles nötig**: Test-Targets benötigen keine spezifischen Provisioning Profiles
2. **Einheitlicher Bundle Identifier**: Gleiche Bundle ID über alle Plattformen für Konsistenz
3. **Automatische Verwaltung**: Empfohlen für Test-Targets zur Minimierung von Konfigurations-Overhead
4. **Multi-Platform Support**: Gleiche Signing-Identität für iOS und visionOS

## Best Practices

1. Verwenden Sie automatische Signing-Verwaltung für Test-Targets
2. Halten Sie Bundle Identifier konsistent mit Hauptprojekt-Struktur
3. Nutzen Sie dieselbe Team-ID wie die Haupt-App
4. Keine manuellen Provisioning Profiles für Test-Targets erforderlich

## Referenzierter Screenshot
[screenshot_2025-04-19_signing-capabilities]

## Gefunden in Chat
2025-04-19 - Xcode-Reference Privacy Filter Test
