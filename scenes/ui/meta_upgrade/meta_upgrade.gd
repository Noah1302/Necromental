extends Control

@onready var label_corpses: Label = %CorpsesLabel
@onready var label_bone: Label = %BoneDustLabel
@onready var label_soul: Label = %SoulLabel

@onready var btn_upgrade_essence: Button = %BtnUpgradeEssence
@onready var btn_upgrade_regen: Button = %BtnUpgradeRegen
@onready var btn_back: Button = %BackBtn
@onready var btn_debug: Button = %DebugGrantBtn

func _ready() -> void:
	btn_back.pressed.connect(_on_back_pressed)
	btn_debug.pressed.connect(_on_debug_grant)
	
	btn_upgrade_essence.pressed.connect(_on_upgrade_essence)
	btn_upgrade_regen.pressed.connect(_on_upgrade_regen)
	
	GameState.meta_resources_changed.connect(_update_ui)
	
	_setup_button_animations(btn_upgrade_essence)
	_setup_button_animations(btn_upgrade_regen)
	_setup_button_animations(btn_back)
	_setup_button_animations(btn_debug)
	
	_update_ui()
	btn_back.grab_focus()

func _update_ui() -> void:
	var save = GameState.current_save
	label_corpses.text = "Corpses: " + str(save.meta_corpses)
	label_bone.text = "Bone Dust: " + str(save.meta_bone_dust)
	label_soul.text = "Souls: " + str(save.meta_soul_essence)
	
	_update_upgrade_button(btn_upgrade_essence, "upg_max_essence", 10, 0, 0)
	_update_upgrade_button(btn_upgrade_regen, "upg_essence_regen", 0, 5, 0)

func _update_upgrade_button(btn: Button, upgrade_id: String, cost_c: int, cost_b: int, cost_s: int) -> void:
	if GameState.has_upgrade(upgrade_id):
		btn.disabled = true
		btn.text = btn.text.split("\n")[0] + "\n(PURCHASED)"
	else:
		var can_afford = GameState.current_save.meta_corpses >= cost_c and \
						 GameState.current_save.meta_bone_dust >= cost_b and \
						 GameState.current_save.meta_soul_essence >= cost_s
		btn.disabled = not can_afford

func _on_upgrade_essence() -> void:
	GameState.purchase_upgrade("upg_max_essence", 10, 0, 0)

func _on_upgrade_regen() -> void:
	GameState.purchase_upgrade("upg_essence_regen", 0, 5, 0)

func _on_debug_grant() -> void:
	GameState.current_save.debug_grant_resources(50)
	GameState.meta_resources_changed.emit()

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu/main_menu.tscn")

func _setup_button_animations(btn: Button) -> void:
	btn.mouse_entered.connect(func(): _animate_button(btn, 1.05, Color(0.8, 0.6, 0.9, 1.0)))
	btn.mouse_exited.connect(func(): _animate_button(btn, 1.0, Color(1, 1, 1, 1)))
	btn.focus_entered.connect(func(): _animate_button(btn, 1.05, Color(0.8, 0.6, 0.9, 1.0)))
	btn.focus_exited.connect(func(): _animate_button(btn, 1.0, Color(1, 1, 1, 1)))
	btn.pivot_offset = btn.custom_minimum_size / 2.0

func _animate_button(btn: Button, target_scale: float, target_modulate: Color) -> void:
	if btn.disabled:
		return
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(btn, "scale", Vector2(target_scale, target_scale), 0.15)
	tween.tween_property(btn, "modulate", target_modulate, 0.15)
