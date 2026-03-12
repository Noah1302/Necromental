class_name SaveData
extends Resource

@export var unlocked_floors: Array[String] = []
@export var meta_corpses: int = 0
@export var meta_bone_dust: int = 0
@export var meta_soul_essence: int = 0
@export var purchased_upgrades: Array[String] = []
@export var last_selected_floor: String = ""

const SAVE_PATH = "user://save_data.tres"

static func load_or_create() -> SaveData:
	if ResourceLoader.exists(SAVE_PATH):
		var data = ResourceLoader.load(SAVE_PATH) as SaveData
		if data:
			return data
	
	return SaveData.new()

func save() -> void:
	ResourceSaver.save(self, SAVE_PATH)
