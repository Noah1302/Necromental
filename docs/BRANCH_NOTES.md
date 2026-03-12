# BRANCH NOTES

## Branch: feature/menu-floor-select

**Ziel:**
Ausbau des Main Menus und Floor Select Screens für dynamische Content-Ladeprozesse anhand der SaveData und FloorData Resources.

**Änderungen:**
- `FloorData` Instanzen `floor_1.tres`/`floor_2.tres`/`floor_3.tres` angelegt.
- `GameState` Autoload liest nun `FloorData` ein und prüft Unlocks bei Start.
- `floor_select.gd` und `main_menu.gd` mit Tween-Animationen (Skalierung/Farbe) aufgewertet.
- Dynamische Darstellung der Level-Namen im Floor Select eingebaut.
- Dummy `Arena`-Szene erstellt, zu der man vom Floor Select wechseln kann.

**Teststatus:**
- Getestet via Play in Godot. Menü-Animationen funktionieren. Logik für gesperrte Floors greift.

**Review-/Merge-Hinweise:**
- Bitte prüfen, ob der Übergang vom Menü in die Arena-Szene so wie gewünscht funktioniert.
