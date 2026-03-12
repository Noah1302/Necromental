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
	
	_setup_button_animations(back_button)
	_setup_button_animations(floor_1_btn)
	_setup_button_animations(floor_2_btn)
	_setup_button_animations(floor_3_btn)
	
	_update_floor_buttons()
	floor_1_btn.grab_focus()

func _setup_button_animations(btn: Button) -> void:
	btn.mouse_entered.connect(func(): _animate_button(btn, 1.05, Color(0.8, 0.6, 0.9, 1.0)))
	btn.mouse_exited.connect(func(): _animate_button(btn, 1.0, Color(1, 1, 1, 1)))
	btn.focus_entered.connect(func(): _animate_button(btn, 1.05, Color(0.8, 0.6, 0.9, 1.0)))
	btn.focus_exited.connect(func(): _animate_button(btn, 1.0, Color(1, 1, 1, 1)))
	btn.pivot_offset = btn.size / 2.0

func _animate_button(btn: Button, target_scale: float, target_modulate: Color) -> void:
	if btn.disabled:
		return
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(btn, "scale", Vector2(target_scale, target_scale), 0.15)
	tween.tween_property(btn, "modulate", target_modulate, 0.15)

func _update_floor_buttons() -> void:
	# Verstecke/Deaktiviere erstmal alle
	floor_1_btn.disabled = true
	floor_2_btn.disabled = true
	floor_3_btn.disabled = true
	
	var unlocked = GameState.current_save.unlocked_floors
	
	if GameState.available_floors.has("floor_1"):
		floor_1_btn.text = GameState.available_floors["floor_1"].floor_name
		if unlocked.has("floor_1"):
			floor_1_btn.disabled = false
			
	if GameState.available_floors.has("floor_2"):
		if unlocked.has("floor_2"):
			floor_2_btn.disabled = false
			floor_2_btn.text = GameState.available_floors["floor_2"].floor_name
		else:
			floor_2_btn.text = GameState.available_floors["floor_2"].floor_name + " (Locked)"
			
	if GameState.available_floors.has("floor_3"):
		if unlocked.has("floor_3"):
			floor_3_btn.disabled = false
			floor_3_btn.text = GameState.available_floors["floor_3"].floor_name
		else:
			floor_3_btn.text = GameState.available_floors["floor_3"].floor_name + " (Locked)"

func _on_floor_selected(floor_id: String) -> void:
	GameState.current_floor_id = floor_id
	print("Starting Run on: ", floor_id)
	get_tree().change_scene_to_file("res://scenes/game/floor/arena.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu/main_menu.tscn")
