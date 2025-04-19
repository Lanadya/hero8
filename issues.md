# Probleme und Lösungen

## 1. Zeichenbegrenzte Chat-Eingaben

**Problem**: 
Viele Chat-Sessions haben nur noch 20-30 Zeichen Eingaberaum, was das Extrahieren von Informationen erschwert.

**Lösung**: 
- Entwicklung des Minimalbefehls `./e` (nur 3 Zeichen)
- Alternative `. e` (Punkt, Leerzeichen, e) für noch weniger Zeichen
- Automatische Extraktion ohne weitere Interaktion erforderlich

---

## 2. Schutz persönlicher Daten in öffentlichen Repositories

**Problem**: 
Screenshots und Dokumentation enthalten oft persönliche Informationen wie E-Mail-Adressen, Namen oder Apple Developer IDs.

**Lösung**: 
- Implementierung eines automatischen Privacy-Filters
- Systematisches Ersetzen sensibler Daten durch Platzhalter
- Filter-Log zur Überprüfung der Ersetzungen

---

## 3. Screenshot-Transfer in GitHub

**Problem**: 
KI kann Screenshots im Chat sehen, aber nicht direkt als Bilddateien exportieren.

**Lösung**: 
- Referenz-System für Screenshots mit eindeutigen IDs
- Placeholder-Dateien in der Dokumentation
- Manuelles Ersetzen der Placeholder durch echte Screenshots
- Dokumentation enthält die Referenz für spätere Zuordnung

---

## 4. Framework-Referenzierung in Xcode

**Problem**: 
Framework-Dateien existieren im Dateisystem, sind aber nicht in Xcode referenziert.

**Lösung**: 
- Strukturierte Dokumentation der notwendigen Schritte
- Warnung in Übergabedokumenten für nachfolgende KI-Sessions
- Schritt-für-Schritt-Anleitung für korrekte Integration

---

## 5. Chat-Session-Unterbrechungen

**Problem**: 
Chat-Sessions können abrupt enden, wodurch Informationen verloren gehen könnten.

**Lösung**: 
- Automatische Zwischenspeicherung alle 5 Minuten
- Strukturierte Übergabedokumentation
- Git-basierte Sicherung nach jeder wichtigen Änderung

---

## 6. Manuelle Extraktion alter Chat-Inhalte

**Problem**: 
Wertvolle Informationen in alten Chats sind schwer manuell zu extrahieren.

**Lösung**: 
- Automatisierter Extraktionsprozess
- Strukturierte Verzeichnisorganisation nach Datum
- Markdown-Format für bessere Durchsuchbarkeit

---

## 7. KI-Session-Kontinuität

**Problem**: 
Neue KI-Sessions haben keinen Kontext über vorherige Arbeit.

**Lösung**: 
- Zentrale Übergabedokumente mit kritischen Informationen
- Schnellstart-Befehl für optimierten Einstieg
- Dokumentierte Systemfähigkeiten (MCP etc.)

---

## 8. Inkonsistente Build-Einstellungen zwischen Debug und Release

**Problem**: 
Build-Konfigurationen können inkonsistent sein und zu unerwarteten Verhaltensweisen führen.

**Lösung**: 
- Dokumentation der optimalen Einstellungen für Test-Targets
- Klare Trennung zwischen Debug- und Release-Konfigurationen
- Best Practices für Multi-Platform-Support

<!-- Geprüft am 2025-04-19: Alle persönlichen Daten maskiert -->
