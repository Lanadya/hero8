## CURRENT ACTIVE WORK: Migration von hero8/hero9 zu hero10

### Status: KRITISCHE NEUAUSRICHTUNG
Wir haben beschlossen, ein komplett neues Projekt (hero10) zu erstellen, um strukturelle Probleme zu vermeiden und die Erkenntnisse aus den vorherigen Migrationsversuchen zu nutzen.

### Aktuelle Erkenntnisse
- Xcode 16.3 (16E140) generiert Info.plist-Dateien für Frameworks automatisch
- Framework-Struktur muss sorgfältig überprüft werden, um Verschachtelungen zu vermeiden
- Bundle-Identifier werden korrekt generiert und folgen dem Schema com.teccolino.xxx
- In xcode-reference wurde die Dokumentation für modernes Framework-Management aktualisiert
- Die UI und Terminologie in Xcode 16.3 hat sich geändert (z.B. "New Folder" statt "New Group" in Kontextmenüs)
- Alle Hilfestellungen müssen die tatsächlich verfügbaren Options in der aktuellen Xcode-Version berücksichtigen

### Unmittelbare nächste Schritte
1. Neue hero10-Projektstruktur gemäß der Dokumentation anlegen
2. Skripte aktualisieren (ki_handover.sh, update_current_work.sh, secure_auto_push.sh)
3. Saubere modulare Framework-Struktur einrichten (CoreDomain, CoreInfrastructure, HeroCoreData)
4. Korrekte Framework-Abhängigkeiten konfigurieren
5. Code aus hero8 nach erfolgreicher Framework-Einrichtung migrieren

### Technischer Kontext
- Bisherige Probleme waren hauptsächlich struktureller Natur (verschachtelte Frameworks)
- Xcode 16.3 bietet verbesserte Unterstützung für modernes Framework-Management
- Fokus liegt auf einer sauberen, nicht-verschachtelten Architektur
- Xcode-Screenshots und tatsächlich verfügbare Optionen müssen genau beachtet werden
- KI-Assistenten müssen die bereitgestellten Screenshots genau analysieren und nicht auf veraltetes Wissen zurückgreifen

### Blockierende Probleme
- Keine - der Weg für einen Neustart mit hero10 ist frei

### Wichtig für nächste KI-Session
- Bitte die Projektstruktur von Grund auf neu aufbauen
- Bei jedem Schritt die korrekte Ordnerstruktur überprüfen
- Nach jedem wichtigen Meilenstein einen Test-Build durchführen
- Dokumentation während des Prozesses aktualisieren
- Besonders auf nicht-verschachtelte Frameworks achten