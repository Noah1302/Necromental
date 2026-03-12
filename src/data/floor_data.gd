class_name FloorData
extends Resource

@export var floor_id: String
@export var floor_name: String
@export var is_unlocked_by_default: bool = false
@export var enemy_kill_threshold: int = 40
@export var essence_reward_base: int = 100

# Hier können später Gegner-Spawnpools etc. definiert werden
