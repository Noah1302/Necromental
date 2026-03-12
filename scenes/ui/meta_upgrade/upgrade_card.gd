extends PanelContainer

signal card_selected(upgrade_data: MetaUpgradeData, card_ref: Control)
signal card_clicked(upgrade_data: MetaUpgradeData)

@onready var title_label: Label = %TitleLabel
@onready var status_label: Label = %StatusLabel
@onready var icon_rect: ColorRect = %IconRect
@onready var highlight_rect: ReferenceRect = %HighlightRect

var data: MetaUpgradeData
var is_ready: bool = false

func _ready() -> void:
	is_ready = true
	if data:
		_setup_visuals()
	
	mouse_entered.connect(_on_focus)
	mouse_exited.connect(_on_unfocus)
	focus_entered.connect(_on_focus)
	focus_exited.connect(_on_unfocus)
	
	pivot_offset = custom_minimum_size / 2.0
	
	# Default styling
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.1, 0.1, 0.12, 1.0)
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.border_color = Color(0.2, 0.2, 0.25, 1.0)
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	add_theme_stylebox_override("panel", style)

func setup(upgrade_data: MetaUpgradeData) -> void:
	data = upgrade_data
	if is_ready:
		_setup_visuals()

func _setup_visuals() -> void:
	title_label.text = data.title
	_update_visuals()

func _update_visuals() -> void:
	if not data or not is_ready:
		return
		
	var is_locked = data.is_locked()
	var is_purchased = data.is_purchased()
	var can_afford = data.can_afford()
	
	if is_locked:
		modulate = Color(0.4, 0.4, 0.4, 0.8)
		status_label.text = "LOCKED"
		status_label.add_theme_color_override("font_color", Color(0.8, 0.3, 0.3))
	elif is_purchased:
		modulate = Color(1.0, 1.0, 1.0, 1.0)
		status_label.text = "PURCHASED"
		status_label.add_theme_color_override("font_color", Color(0.6, 0.8, 0.9))
		icon_rect.color = Color(0.3, 0.2, 0.5, 1.0) # Purple tint
	elif can_afford:
		modulate = Color(1.0, 1.0, 1.0, 1.0)
		status_label.text = "AVAILABLE"
		status_label.add_theme_color_override("font_color", Color(0.6, 0.9, 0.6))
	else:
		modulate = Color(0.8, 0.8, 0.8, 1.0)
		status_label.text = "NEED RESOURCES"
		status_label.add_theme_color_override("font_color", Color(0.8, 0.6, 0.6))

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		card_clicked.emit(data)



func _on_focus() -> void:
	highlight_rect.visible = true
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1.03, 1.03), 0.1)
	card_selected.emit(data, self)

func _on_unfocus() -> void:
	highlight_rect.visible = false
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)

func set_active(active: bool) -> void:
	var style = get_theme_stylebox("panel").duplicate() as StyleBoxFlat
	if active:
		style.border_color = Color(0.65, 0.35, 0.9, 1.0) # Purple border
	else:
		style.border_color = Color(0.2, 0.2, 0.25, 1.0)
	add_theme_stylebox_override("panel", style)
