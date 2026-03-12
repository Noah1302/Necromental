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
- Incremental Menu Overhaul (Ritual Altar) auf Branch `feature/incremental-upgrade-menu`:
  - `MetaUpgradeData` Resource eingeführt, um Upgrades datengetrieben zu gestalten (inkl. Kategorien, Tiers, Voraussetzungen).
  - Wiederverwendbare `UpgradeCard` mit Hover-Tweens und Status-Visualisierung (Locked, Available, Purchased) integriert.
- Ritual Tree Web Overhaul auf Branch `feature/ritual-tree-web`:
  - Tab-System und Grids komplett entfernt zugunsten eines unendlichen, scrollbaren/zoombaren Netzwerks (Tech Tree Style).
  - Neue `TreeNode` Komponente für kompaktere Desktop-orientierte Knotenpunkte erstellt.
  - Generisches Linien-Ziehen im CanvasLayer (Verbindungen zwischen `parent_ids` und Child-Nodes leuchten bei aktivem Status auf).
  - 15 Node starkes Dummy-Netzwerk generiert (Root -> Essence / Minions / Harvest / Rituals), um die Progression erfahrbar zu machen.
