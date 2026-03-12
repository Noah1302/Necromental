extends Control

@onready var start_button: Button = $CenterContainer/VBox/StartButton
@onready var quit_button: Button = $CenterContainer/VBox/QuitButton

func _ready() -> void:
	start_button.pressed.connect(_on_start_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	
	# Fokus für Gamepad/Keyboard Navigation
	start_button.grab_focus()

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/floor_select/floor_select.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
