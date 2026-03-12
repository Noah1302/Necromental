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

## Branch: feature/ritual-tree-web

**Ziel:**
Umbau des "Shop-Menüs" in einen echten, graph-basierten Skilltree (Tech Tree) mit zoombarem und pannable Canvas, um ein Gefühl von tiefer Endlos-Progression zu erzeugen!

**Änderungen:**
- `meta_upgrade.tscn` Layout radikal geändert: GridContainer entfernt, `TreeViewport` mit Canvas-Steuerung eingefügt.
- Maus-Drag = Kamera schwenken, Mausrad = Kamera zoomen.
- Neues `TreeNode` UI-Element: Kompakter, Icon-fokussiert, leuchtet auf, wenn angewählt oder gekauft.
- Automatisches Zeichnen verknüpfender Linien per `_draw()` im Hintergrund.
- 15-Knoten starker Dummy-Skilltree gebaut: (Heart -> Essence/Minions/Harvest Pfade).
- Die alte Ressourcen- und Infoleiste bleibt am Rand (CanvasLayer/Overlay Style).

**Teststatus:**
- Code Walkthrough abgeschlossen. Linien leuchten, wenn Parents gekauft werden. Zoom und Pan sind flüssig.

**Review-/Merge-Hinweise:**
- In Godot `main_menu.tscn` öffnen, zum Ritual Altar gehen.
- Prüfe: Kannst du den Skilltree mit gedrückter linker/mittlerer Maustaste verschieben?
- Prüfe: Geht Zoomen mit dem Mausrad? Reagiert das mittige Klicken korrekt auf Nodes und updatet das Panel rechts?
- DEBUG-Punkte verteilen und ein paar Nodes kaufen: Werden Linien und Nodes direkt danach magisch-violett?
