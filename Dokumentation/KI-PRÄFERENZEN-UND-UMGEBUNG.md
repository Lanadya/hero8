# Wichtige Hinweise für KI-Assistenz

## Entwicklungsumgebung

- **Xcode Version**: 16.3 (16E140)
- **Multiplatform Projekt**: hero8 unterstützt iOS, macOS, visionOS (xros)
- **Betriebsystem**: macOS 15.4 (basierend auf den Build-Einstellungen)
- **Development Team**: 5ZQ2L7WC24
- **Bundle Identifier**: com.teccolino.hero8

## Sehr wichtige Präferenzen der Entwicklerin

1. **AUSFÜHRLICHE ANLEITUNGEN**: Die Entwicklerin bevorzugt sehr detaillierte, schrittweise Anleitungen
   - Jeden Klick erklären
   - Vermeiden von Tastaturkürzeln in Anleitungen (nur wenn explizit gewünscht)
   - Klare Mausnavigation beschreiben
   - Jeden Dialog und jede Einstellung genau benennen

2. **VORSICHT BEI XCODE-INTEGRATION**: 
   - Die Entwicklerin verwendet die Maus für präzise Aktionen
   - Tastaturkürzel können zu verschachtelten oder falschen Strukturen führen
   - Immer explizit prüfen, dass Frameworks/Targets auf der richtigen Ebene landen

3. **BEST PRACTICES**: 
   - Vor jeder größeren Änderung Backup-Plan bereitstellen
   - Bei Framework-Erstellung einzeln und nacheinander vorgehen
   - Strukturen immer visuell prüfen lassen (mit Screenshots/Beschreibungen)
   - Fehler sofort korrigieren und nicht weiterarbeiten

4. **DOKUMENTATION**: 
   - Entwicklerin schätzt ausführliche Dokumentation
   - Änderungen immer sofort in Git sichern
   - Übergabedokumente für andere KIs aktuell halten

## Typische Probleme und Lösungen

1. **Framework-Verschachtelung**: 
   - Tritt auf bei Verwendung von Tastaturkürzeln statt Mausnavigation
   - Lösung: Frameworks einzeln mit Maus anlegen und Struktur prüfen

2. **Build-Fehler**: 
   - Regelmäßig prüfen, ob Targets korrekt konfiguriert sind
   - Xcode 16.3 hat spezifische Anforderungen an Multiplatform-Projekte

## Aktueller Stand

Entwicklerin erstellt gerade die drei Framework-Targets:
1. CoreDomain
2. CoreInfrastructure 
3. HeroCoreData

Nach erfolgreicher Erstellung müssen folgende Schritte durchgeführt werden:
- Abhängigkeiten zwischen Frameworks einrichten
- Dateien den entsprechenden Targets zuweisen
- Build-Einstellungen konfigurieren
- Testbuild durchführen