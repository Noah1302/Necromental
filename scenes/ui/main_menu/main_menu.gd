extends Control

@onready var start_button: Button = $CenterContainer/VBox/StartButton
@onready var altar_button: Button = $CenterContainer/VBox/OptionsButton
@onready var quit_button: Button = $CenterContainer/VBox/QuitButton

func _ready() -> void:
	start_button.pressed.connect(_on_start_pressed)
	altar_button.pressed.connect(_on_altar_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	
	_setup_button_animations(start_button)
	_setup_button_animations(altar_button)
	_setup_button_animations(quit_button)
	
	# Fokus für Gamepad/Keyboard Navigation
	start_button.grab_focus()

func _setup_button_animations(btn: Button) -> void:
	btn.mouse_entered.connect(func(): _animate_button(btn, 1.1, Color(0.8, 0.6, 0.9, 1.0)))
	btn.mouse_exited.connect(func(): _animate_button(btn, 1.0, Color(1, 1, 1, 1)))
	btn.focus_entered.connect(func(): _animate_button(btn, 1.1, Color(0.8, 0.6, 0.9, 1.0)))
	btn.focus_exited.connect(func(): _animate_button(btn, 1.0, Color(1, 1, 1, 1)))
	# Set pivot to center for scaling
	btn.pivot_offset = btn.custom_minimum_size / 2.0

func _animate_button(btn: Button, target_scale: float, target_modulate: Color) -> void:
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(btn, "scale", Vector2(target_scale, target_scale), 0.15)
	tween.tween_property(btn, "modulate", target_modulate, 0.15)

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/floor_select/floor_select.tscn")

func _on_altar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/meta_upgrade/meta_upgrade.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
