# BRANCH NOTES

## Branch: feature/save-data-meta-base

**Ziel:**
Implementation des Speichersystems für Meta-Ressourcen und Basis-UI ("Ritual Altar") für permanente Upgrades.

**Änderungen:**
- `SaveData` mit Logik zum Speichern in `user://save_data.tres` (inklusive Debug Helper).
- `GameState` erweitert um Transaktionen (`spend_meta_resources`, `purchase_upgrade`).
- `MetaUpgrade.tscn` erstellt (inkl. Ressourcen-Tracking und Dummy-Upgrades).
- `MainMenu` Option-Button umgerüstet zum "RITUAL ALTAR" Button, der ins Upgrade Menu führt.

**Teststatus:**
- Getestet via Code Walkthrough. Save- und Load-Cycles wurden eingerichtet.

**Review-/Merge-Hinweise:**
- Bitte in Godot testen: In "Ritual Altar" gehen, "DEBUG: +50 All" drücken, Upgrades kaufen, Spiel schließen und neu starten. Danach wieder prüfen, ob Ressourcen & Upgrades erhalten bleiben.

## Branch: feature/incremental-upgrade-menu

**Ziel:**
Überarbeitung des Ritual Altars in ein vollwertiges, ressourcengesteuertes Incremental-Progression-Menü.

**Änderungen:**
- `MetaUpgradeData` Resource erstellt für datengetriebene Upgrades.
- `UpgradeCard` Komponente erstellt zur Darstellung einzelner Knoten im Grid mit Visual States (Locked, Available, Purchased).
- `meta_upgrade.tscn` (Ritual Altar) komplett überarbeitet: Fixed Top-Bar, linke Tab-Navigation (Essence, Minions, etc.), dynamisches Grid, dynamisches Detail-Panel rechts (zeigt Kosten, Voraussetzungen und Effekte des fokussierten/gehoverten Upgrades).
- Dummy Upgrade Daten für Essence und Minions angelegt.

**Teststatus:**
- Code Walkthrough abgeschlossen.

**Review-/Merge-Hinweise:**
- In Godot `main_menu.tscn` öffnen, zum Ritual Altar gehen, Tabs wechseln, Hover-Effekte und Detail-Panel-Updates prüfen. Debug-Button nutzen, um Upgrades kaufbar zu machen und Transition in "PURCHASED" Status zu sichten.
