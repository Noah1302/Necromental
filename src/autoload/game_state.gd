extends Node

signal essence_changed(current: int, max_amount: int)
signal meta_resources_changed

var current_save: SaveData

var run_essence: int = 0
var run_max_essence: int = 100
var current_floor_id: String = ""

var available_floors: Dictionary = {}

func _ready() -> void:
	_load_floor_data()
	
	# Lade die Speicherdaten beim Start
	current_save = SaveData.load_or_create()
	
	# Initial unlock handling
	_handle_default_unlocks()

func _load_floor_data() -> void:
	# In a real game, you might want to read a directory, but hardcoding for Phase 2 is safer
	var f1 = load("res://data/floors/floor_1.tres") as FloorData
	var f2 = load("res://data/floors/floor_2.tres") as FloorData
	var f3 = load("res://data/floors/floor_3.tres") as FloorData
	
	if f1: available_floors[f1.floor_id] = f1
	if f2: available_floors[f2.floor_id] = f2
	if f3: available_floors[f3.floor_id] = f3

func _handle_default_unlocks() -> void:
	for floor_id in available_floors.keys():
		var fd = available_floors[floor_id] as FloorData
		if fd.is_unlocked_by_default and not current_save.unlocked_floors.has(floor_id):
			current_save.unlocked_floors.append(floor_id)
			
	if current_save.unlocked_floors.is_empty():
		# Fallback just in case
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

func spend_meta_resources(corpses: int, bone_dust: int, soul_essence: int) -> bool:
	if current_save.meta_corpses >= corpses and current_save.meta_bone_dust >= bone_dust and current_save.meta_soul_essence >= soul_essence:
		current_save.meta_corpses -= corpses
		current_save.meta_bone_dust -= bone_dust
		current_save.meta_soul_essence -= soul_essence
		current_save.save()
		meta_resources_changed.emit()
		return true
	return false

func purchase_upgrade(upgrade_id: String, cost_corpses: int, cost_bone_dust: int, cost_soul_essence: int) -> bool:
	if current_save.purchased_upgrades.has(upgrade_id):
		return false # Already owned
		
	if spend_meta_resources(cost_corpses, cost_bone_dust, cost_soul_essence):
		current_save.purchased_upgrades.append(upgrade_id)
		current_save.save()
		return true
		
	return false

func has_upgrade(upgrade_id: String) -> bool:
	return current_save.purchased_upgrades.has(upgrade_id)

func unlock_floor(floor_id: String) -> void:
	if not current_save.unlocked_floors.has(floor_id):
		current_save.unlocked_floors.append(floor_id)
		current_save.save()

func set_run_essence(amount: int) -> void:
	run_essence = amount
	essence_changed.emit(run_essence, run_max_essence)
