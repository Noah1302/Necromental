extends Node

signal essence_changed(current: int, max_amount: int)
signal meta_resources_changed

var current_save: SaveData

var run_essence: int = 0
var run_max_essence: int = 100
var current_floor_id: String = ""

func _ready() -> void:
	# Lade die Speicherdaten beim Start
	current_save = SaveData.load_or_create()
	
	# Floor 1 standardmäßig freischalten, wenn es keine gibt
	if current_save.unlocked_floors.is_empty():
		current_save.unlocked_floors.append("floor_1")
		current_save.save()

func save_game() -> void:
	if current_save:
		current_save.save()

func add_meta_resources(corpses: int, bone_dust: int, soul_essence: int) -> void:
	current_save.meta_corpses += corpses
	current_save.meta_bone_dust += bone_dust
	current_save.meta_soul_essence += soul_essence
	current_save.save()
	meta_resources_changed.emit()

func unlock_floor(floor_id: String) -> void:
	if not current_save.unlocked_floors.has(floor_id):
		current_save.unlocked_floors.append(floor_id)
		current_save.save()

func set_run_essence(amount: int) -> void:
	run_essence = amount
	essence_changed.emit(run_essence, run_max_essence)
