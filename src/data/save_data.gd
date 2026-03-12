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
	
	# Initial creation needs to ensure arrays are valid
	var new_save = SaveData.new()
	new_save.unlocked_floors = []
	new_save.purchased_upgrades = []
	return new_save

func save() -> void:
	# Ensure the directory exists
	var dir = DirAccess.open("user://")
	if not dir:
		DirAccess.make_dir_absolute("user://")
		
	ResourceSaver.save(self, SAVE_PATH)

# Debug helper
func debug_grant_resources(amount: int) -> void:
	meta_corpses += amount
	meta_bone_dust += amount
	meta_soul_essence += amount
	save()
