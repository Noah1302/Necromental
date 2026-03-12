# ARCHITECTURE

## Szenenstruktur
- `Main`: Start-Boot, lädt die entsprechenden Menüs
- `UI`:
  - `MainMenu`: Startbildschirm
  - `FloorSelect`: Auswahl des Levels
  - `HUD`: Ingame-Interface (Essenz, Kill-Counter, Boss-Timer, Commands, Summons)
  - `PostRunResult`: Anzeige der Meta-Ressourcen nach einem Run
  - `MetaUpgrade`: Screen für permanente Upgrades
- `Game`:
  - `Floor/Arena`: Container für den aktuellen Run
  - `Core/Necromancer`: Das zentrale stationäre Target
  - `Minions/`: Einzelne Entity-Szenen (SkeletonGuard, GhoulCollector, GraveArcher)
  - `Enemies/`: Angreifer (BasicRunner, Bruiser, RangedCaster, Bosses)

## Script-Architektur
- **SaveData** (`Resource`): Persistente Daten (freigeschaltete Floors, Upgrades, Währungen).
- **FloorData** (`Resource`): Definition der Floors (Gegnertypen, Spawnraten, Bossschwelle, Belohnungen).
- **SummonData** / **MinionData** (`Resource`): Werte pro Minion-Typ (Kosten, Cooldown, Limits).
- **EnemyData** (`Resource`): Stats für Gegner.

## Datenfluss und Systemverantwortungen
- **GameState (Autoload)**: Hält den aktuellen Laufzeit-Status (ausgewählter Floor, Session-Ressourcen, Referenz auf SaveData).
- **RunManager**: Verwaltet den Ablauf des aktuellen Runs (Kill-Count, Boss-Spawn, Sieg/Niederlage).
- **SummonSystem**: Regelt Cooldowns, Kosten und Instantiate von Minions.
- **CommandSystem**: Leitet Spieler-Befehle (Defend, Assault, Gather, Boss, Recall) an die Minions weiter.
- **EssenceSystem**: Generiert passiv und aktiv (über Events) die Hauptressource Essenz während eines Runs.

## Signals vs. Kopplung
- Wir verwenden Signals für Event-basierte Kommunikation (z.B. `enemy_died(amount)`, `essence_changed(current, max)`, `command_issued(type)`).
- Direkte Funktionsaufrufe primär top-down (z.B. `RunManager` ruft `SpawnSystem` auf).
