#!/bin/bash

# Skript zum Aufräumen des xcode-reference Repositories
# Erstellt am: 2025-04-19

# Aktuelles Verzeichnis merken
ORIGINAL_DIR=$(pwd)

echo "🧹 Starte Aufräumarbeiten im xcode-reference Repository..."

# Zu xcode-reference wechseln
cd /Users/ninaklee/Projects/xcode-reference

# Backup-Dateien entfernen
echo "🗑️ Entferne Backup-Dateien..."
find versions/16.3/docs -name "*.backup" -type f -delete

# Roadmap korrigieren
echo "📝 Korrigiere ROADMAP..."
cat << 'EOF' > versions/16.3/docs/community/ROADMAP.md
# xcode-reference 16.3 Roadmap

**Stand**: April 2025  
**Ziel**: Umfassende Dokumentationssammlung für Xcode 16.3 Best Practices

## Vision

Das xcode-reference Repository sammelt und teilt praktische Erfahrungen aus realen iOS-Entwicklungsprojekten. Der Fokus liegt auf dokumentierten Lösungen für häufige Probleme und bewährten Entwicklungspraktiken.

## Projektphasen

### Phase 1: Grundlagen (abgeschlossen) ✅
- Thread-Safety Dokumentation
- Build-Konfiguration Richtlinien
- Modularisierungsmuster
- Workflow-Dokumentation
- Code Review Guidelines
- Projekt-Setup Checkliste
- Debugging-Strategien

### Phase 2: Testautomatisierung (geplant) 🚧
- Automatisierte Testing-Guides
- CI/CD Integration
- Performance Testing Strategien
- UI Testing Best Practices

### Phase 3: Fortgeschrittene Themen (in Planung) 📋
- Advanced Asset Management
- Multi-Platform Development
- Accessibility Richtlinien
- Security Best Practices

### Phase 4: Dokumentationserweiterung (langfristig) 📋
- Interaktive Code-Beispiele
- Erweiterte Dokumentationen
- Fortgeschrittene Debugging-Guides
- Architektur-Beispiele

## Community-Beiträge

Beiträge zur Dokumentation werden begrüßt:

1. **Erfahrungsberichte**: Dokumentieren Sie Ihre Lösungen für reale Probleme
2. **Code-Beispiele**: Zeigen Sie praktische Implementierungen
3. **Korrekturen**: Helfen Sie, die Dokumentation aktuell zu halten
4. **Erweiterungen**: Ergänzen Sie bestehende Dokumentationen

## Technische Entwicklung

### Repository-Struktur
- Versionsspezifische Dokumentation
- Migrations-Guides zwischen Versionen
- Archiv für ältere Versionen

## Meilensteine

- **Q2 2025**: Testing-Dokumentation fertigstellen
- **Q3 2025**: Multi-Platform Guide veröffentlichen
- **Q4 2025**: Erweiterte Asset-Management Dokumentation
- **Q1 2026**: Xcode 17 Migration Guide

## Zusammenarbeit

- GitHub Issues für Feature Requests
- Pull Requests für Beiträge
- Diskussionen im Repository für technischen Austausch

---

*Diese Roadmap wird angepasst, wenn sich die Prioritäten oder Bedürfnisse ändern.*
EOF

# Git Status prüfen
echo "🔍 Prüfe Git Status..."
git status

# Commit und Push
echo "💾 Committe Aufräumarbeiten..."
git add -A
git commit -m "Aufräumarbeiten: Backup-Dateien entfernt und realistische Roadmap implementiert

- Alle .backup Dateien entfernt
- ROADMAP.md aktualisiert auf realistische Ziele ohne Workshops
- Klarere Fokussierung auf technische Dokumentation"

echo "🚀 Push nach GitHub..."
git push origin main

# Zurück zum ursprünglichen Verzeichnis
echo "🔙 Kehre zum ursprünglichen Verzeichnis zurück..."
cd "$ORIGINAL_DIR"
echo "📍 Aktuelles Verzeichnis: $(pwd)"
echo "✅ Aufräumarbeiten abgeschlossen!"
