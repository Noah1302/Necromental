extends PanelContainer

signal node_selected(upgrade_data: MetaUpgradeData, node_ref: Control)
signal node_clicked(upgrade_data: MetaUpgradeData)

@onready var icon_rect: ColorRect = %IconRect
@onready var icon_texture: TextureRect = %IconTexture
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
	
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.1, 0.1, 0.12, 1.0)
	style.border_width_left = 3
	style.border_width_top = 3
	style.border_width_right = 3
	style.border_width_bottom = 3
	style.border_color = Color(0.2, 0.2, 0.25, 1.0)
	style.corner_radius_top_left = 40
	style.corner_radius_top_right = 40
	style.corner_radius_bottom_left = 40
	style.corner_radius_bottom_right = 40
	add_theme_stylebox_override("panel", style)

func setup(upgrade_data: MetaUpgradeData) -> void:
	data = upgrade_data
	if is_ready:
		_setup_visuals()

func _setup_visuals() -> void:
	if data.icon:
		icon_texture.texture = data.icon
	
	position = data.tree_position - (custom_minimum_size / 2.0)
	_update_visuals()

func _update_visuals() -> void:
	if not data or not is_ready:
		return
		
	var is_locked = data.is_locked()
	var is_purchased = data.is_purchased()
	var can_afford = data.can_afford()
	
	var style = get_theme_stylebox("panel") as StyleBoxFlat
	if not style: return
	
	var is_root = data.parent_ids.is_empty() and data.tier == 0
	
	if is_root:
		style.border_color = Color(0.8, 0.2, 0.9, 1.0)
		style.bg_color = Color(0.3, 0.1, 0.4, 1.0)
		custom_minimum_size = Vector2(100, 100)
		pivot_offset = custom_minimum_size / 2.0
		position = data.tree_position - (custom_minimum_size / 2.0)
		highlight_rect.border_color = Color(1.0, 0.5, 1.0, 1.0)
	elif is_purchased:
		modulate = Color(1.0, 1.0, 1.0, 1.0)
		style.border_color = Color(0.65, 0.35, 0.9, 1.0) # Purple
		icon_rect.color = Color(0.3, 0.2, 0.5, 1.0)
	elif is_locked:
		modulate = Color(0.4, 0.4, 0.4, 0.8)
		style.border_color = Color(0.2, 0.2, 0.25, 1.0)
		icon_rect.color = Color(0.1, 0.1, 0.1, 1.0)
	elif can_afford:
		modulate = Color(1.0, 1.0, 1.0, 1.0)
		style.border_color = Color(0.4, 0.8, 0.4, 1.0) # Greenish
		icon_rect.color = Color(0.15, 0.12, 0.2, 1.0)
	else:
		modulate = Color(0.8, 0.8, 0.8, 1.0)
		style.border_color = Color(0.5, 0.2, 0.2, 1.0) # Reddish
		icon_rect.color = Color(0.15, 0.12, 0.2, 1.0)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		node_clicked.emit(data)

func _on_focus() -> void:
	highlight_rect.visible = true
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.1)
	node_selected.emit(data, self)

func _on_unfocus() -> void:
	highlight_rect.visible = false
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)

func set_active(active: bool) -> void:
	highlight_rect.visible = active
