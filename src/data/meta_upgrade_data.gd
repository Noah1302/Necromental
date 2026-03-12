class_name MetaUpgradeData
extends Resource

@export var id: String = "upg_id"
@export var title: String = "Upgrade Name"
@export_multiline var description: String = "Description of the upgrade's effects."

@export_enum("Essence", "Minions", "Harvest", "Command", "Core", "Rituals")
var category: String = "Essence"

@export var tier: int = 1
@export var max_level: int = 1

@export_group("Costs")
@export var cost_corpses: int = 0
@export var cost_bone_dust: int = 0
@export var cost_soul_essence: int = 0

@export_group("Requirements")
@export var required_upgrade_id: String = ""
@export var required_floor_id: String = ""

# Visuals
@export var icon: Texture2D

func is_purchased() -> bool:
	return GameState.has_upgrade(id)

func is_locked() -> bool:
	var save = GameState.current_save
	
	if required_upgrade_id != "" and not save.purchased_upgrades.has(required_upgrade_id):
		return true
		
	if required_floor_id != "" and not save.unlocked_floors.has(required_floor_id):
		return true
		
	return false

func can_afford() -> bool:
	var save = GameState.current_save
	return save.meta_corpses >= cost_corpses and \
		   save.meta_bone_dust >= cost_bone_dust and \
		   save.meta_soul_essence >= cost_soul_essence
