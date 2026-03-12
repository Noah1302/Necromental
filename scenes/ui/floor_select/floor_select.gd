extends Control

@onready var back_button: Button = $Margin/Layout/Header/BackButton
@onready var floor_1_btn: Button = $Margin/Layout/FloorList/Floor1Btn
@onready var floor_2_btn: Button = $Margin/Layout/FloorList/Floor2Btn
@onready var floor_3_btn: Button = $Margin/Layout/FloorList/Floor3Btn

func _ready() -> void:
	back_button.pressed.connect(_on_back_pressed)
	floor_1_btn.pressed.connect(func(): _on_floor_selected("floor_1"))
	floor_2_btn.pressed.connect(func(): _on_floor_selected("floor_2"))
	floor_3_btn.pressed.connect(func(): _on_floor_selected("floor_3"))
	
	_update_floor_buttons()
	floor_1_btn.grab_focus()

func _update_floor_buttons() -> void:
	# Prüfen welche Floors freigeschaltet sind über GameState Autoload
	var unlocked = GameState.current_save.unlocked_floors
	
	if unlocked.has("floor_2"):
		floor_2_btn.disabled = false
		floor_2_btn.text = "Floor 2: Bone Vaults"
		
	if unlocked.has("floor_3"):
		floor_3_btn.disabled = false
		floor_3_btn.text = "Floor 3: Soul Chasm"

func _on_floor_selected(floor_id: String) -> void:
	GameState.current_floor_id = floor_id
	print("Starting Run on: ", floor_id)
	# Später: get_tree().change_scene_to_file("res://scenes/game/floor/arena.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu/main_menu.tscn")
