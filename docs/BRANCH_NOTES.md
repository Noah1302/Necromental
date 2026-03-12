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
