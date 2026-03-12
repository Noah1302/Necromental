# DEVLOG

## [Aktuelles Datum]
- Initialisierung des Repositories
- Planung der Architektur für "Necromental"
- Phase 1 (Foundation) gestartet auf Branch `feature/project-foundation`
- Docs-Ordner mit grundlegenden Markdown-Dokumenten angelegt.
- Phase 1 beendet, gemergt.
- Phase 2 (Menu & Floor Select) auf Branch `feature/menu-floor-select` umgesetzt:
  - Dynamische Level-Auswahl via FloorData und GameState.
  - Hover-Tweens für UI-Buttons hinzugefügt.
  - Dummy `Arena` Szene für den Start des Runs angelegt.
- Phase 2 beendet, gemergt.
- Phase 3 (Save Data & Meta Base) auf Branch `feature/save-data-meta-base` umgesetzt:
  - `SaveData` für korrekte Persistence via FileAccess gesichert.
  - `GameState` Funktionen für Ressourcen-Spenden und Upgrade-Kauf impl.
  - `MetaUpgrade` Szene ("Ritual Altar") erstellt und ans Main Menu gekoppelt.
