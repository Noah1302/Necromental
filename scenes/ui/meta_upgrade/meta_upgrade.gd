extends Control

const TREE_NODE_SCENE = preload("res://scenes/ui/meta_upgrade/tree_node.tscn")
const UPGRADES_PATH = "res://data/upgrades/"

@onready var label_corpses: Label = %CorpsesLabel
@onready var label_bone: Label = %BoneDustLabel
@onready var label_soul: Label = %SoulLabel

@onready var tree_viewport: Control = %TreeViewport
@onready var tree_container: Control = %TreeContainer
@onready var lines_layer: Control = %LinesLayer
@onready var nodes_layer: Control = %NodesLayer

@onready var detail_title: Label = %DetailTitle
@onready var detail_desc: Label = %DetailDesc
@onready var detail_req: Label = %DetailReq
@onready var detail_cost: Label = %DetailCost
@onready var btn_purchase: Button = %BtnPurchase

@onready var btn_back: Button = %BackBtn
@onready var btn_debug: Button = %DebugGrantBtn
@onready var btn_center: Button = %CenterCanvas

var all_upgrades: Array = []
var upgrade_dict: Dictionary = {}
var node_dict: Dictionary = {}

var selected_upgrade: Resource
var active_node: Control

var is_panning: bool = false
var current_zoom: float = 1.0
const MIN_ZOOM: float = 0.2
const MAX_ZOOM: float = 2.0

func _ready() -> void:
	btn_back.pressed.connect(_on_back_pressed)
	btn_debug.pressed.connect(_on_debug_grant)
	btn_purchase.pressed.connect(_on_purchase_pressed)
	btn_center.pressed.connect(_on_center_pressed)
	
	GameState.meta_resources_changed.connect(_on_resources_changed)
	
	lines_layer.draw.connect(_on_lines_draw)
	tree_viewport.gui_input.connect(_on_viewport_gui_input)
	
	_load_upgrades()
	print("MetaUpgrade: Loaded ", all_upgrades.size(), " upgrades")
	_build_tree()
	
	_update_resources()
	_clear_details()
	
	btn_back.grab_focus()
	
	# Delay center so layout sizes are correct
	await get_tree().process_frame
	_on_center_pressed()

func _load_upgrades() -> void:
	all_upgrades.clear()
	upgrade_dict.clear()
	
	if not DirAccess.dir_exists_absolute(UPGRADES_PATH):
		print("ERROR: Upgrades path not found: ", UPGRADES_PATH)
		return
		
	var dir = DirAccess.open(UPGRADES_PATH)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".tres"):
				var full_path = UPGRADES_PATH + file_name
				var res = ResourceLoader.load(full_path)
				if res:
					all_upgrades.append(res)
					upgrade_dict[res.id] = res
					print("Loaded upgrade: ", res.id, " at ", res.tree_position)
				else:
					print("FAILED to load resource: ", full_path)
			file_name = dir.get_next()
	else:
		print("FAILED to open upgrades directory")

func _build_tree() -> void:
	for child in nodes_layer.get_children():
		child.queue_free()
	node_dict.clear()
	
	for upg in all_upgrades:
		var node = TREE_NODE_SCENE.instantiate()
		node.setup(upg)
		node.node_selected.connect(_on_node_selected)
		node.node_clicked.connect(func(d): _on_node_selected(d, node); btn_purchase.grab_focus())
		nodes_layer.add_child(node)
		node_dict[upg.id] = node
		
	lines_layer.queue_redraw()

func _on_lines_draw() -> void:
	for upg in all_upgrades:
		for parent_id in upg.parent_ids:
			if upgrade_dict.has(parent_id):
				var parent = upgrade_dict[parent_id]
				var color = Color(0.2, 0.2, 0.25, 1.0)
				var width = 4.0
				
				if upg.is_purchased():
					color = Color(0.65, 0.35, 0.9, 1.0)
					width = 6.0
				elif parent.is_purchased() and not upg.is_locked():
					color = Color(0.4, 0.25, 0.6, 0.8)
					width = 4.0
				
				lines_layer.draw_line(parent.tree_position, upg.tree_position, color, width, true)

func _on_viewport_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_MIDDLE or event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				is_panning = true
			else:
				is_panning = false
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			_apply_zoom(1.1, event.position)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			_apply_zoom(0.9, event.position)
			
	elif event is InputEventMouseMotion and is_panning:
		tree_container.position += event.relative
		lines_layer.queue_redraw()

func _apply_zoom(factor: float, _mouse_pos: Vector2) -> void:
	var old_zoom = current_zoom
	current_zoom = clamp(current_zoom * factor, MIN_ZOOM, MAX_ZOOM)
	
	# var _actual_factor = current_zoom / old_zoom
	
	var local_mouse = tree_container.get_local_mouse_position()
	tree_container.scale = Vector2(current_zoom, current_zoom)
	tree_container.position -= local_mouse * (current_zoom - old_zoom)
	lines_layer.queue_redraw()

func _on_center_pressed() -> void:
	current_zoom = 1.0
	tree_container.scale = Vector2(1.0, 1.0)
	var viewport_size = tree_viewport.size
	# Try to find root node to center on
	var offset = Vector2.ZERO
	for upg in all_upgrades:
		if upg.parent_ids.is_empty() and upg.tier == 0:
			offset = -upg.tree_position
			break
			
	tree_container.position = (viewport_size / 2.0) + offset

func _on_node_selected(data: Resource, node: Control) -> void:
	if active_node and is_instance_valid(active_node) and active_node.has_method("set_active"):
		active_node.set_active(false)
		
	active_node = node
	selected_upgrade = data
	if active_node.has_method("set_active"):
		active_node.set_active(true)
	
	_populate_details(data)

func _populate_details(data: Resource) -> void:
	detail_title.text = data.title
	detail_desc.text = data.description
	
	var plain_cost = ""
	if data.cost_corpses > 0: plain_cost += str(data.cost_corpses) + " Corpses\n"
	if data.cost_bone_dust > 0: plain_cost += str(data.cost_bone_dust) + " Bone Dust\n"
	if data.cost_soul_essence > 0: plain_cost += str(data.cost_soul_essence) + " Souls\n"
	
	detail_cost.text = "Cost:\n" + plain_cost
	
	detail_req.text = ""
	if data.parent_ids.size() > 0:
		var parent_names = []
		for pid in data.parent_ids:
			if upgrade_dict.has(pid):
				parent_names.append(upgrade_dict[pid].title)
			else:
				parent_names.append(pid)
		detail_req.text = "Requires ONE of:\n- " + "\n- ".join(parent_names)
	
	if data.required_floor_id != "":
		detail_req.text += "\nRequires Floor: " + data.required_floor_id
		
	if data.is_locked():
		btn_purchase.disabled = true
		btn_purchase.text = "LOCKED"
	elif data.is_purchased():
		btn_purchase.disabled = true
		btn_purchase.text = "MAXED"
	elif data.can_afford():
		btn_purchase.disabled = false
		btn_purchase.text = "PURCHASE"
	else:
		btn_purchase.disabled = true
		btn_purchase.text = "NOT ENOUGH RESOURCES"

func _clear_details() -> void:
	detail_title.text = "Select a Node"
	detail_desc.text = "Navigate the tree and select a node to view details."
	detail_cost.text = ""
	detail_req.text = ""
	btn_purchase.disabled = true
	btn_purchase.text = ""
	active_node = null
	selected_upgrade = null

func _on_purchase_pressed() -> void:
	if selected_upgrade and not selected_upgrade.is_purchased() and selected_upgrade.can_afford():
		if GameState.purchase_upgrade(selected_upgrade.id, selected_upgrade.cost_corpses, selected_upgrade.cost_bone_dust, selected_upgrade.cost_soul_essence):
			var cache_upg = selected_upgrade
			for c in nodes_layer.get_children():
				c._update_visuals()
			lines_layer.queue_redraw()
			if cache_upg and node_dict.has(cache_upg.id):
				_on_node_selected(cache_upg, node_dict[cache_upg.id])
				btn_purchase.grab_focus()

func _on_resources_changed() -> void:
	_update_resources()
	if selected_upgrade:
		_populate_details(selected_upgrade)
	for c in nodes_layer.get_children():
		c._update_visuals()
	lines_layer.queue_redraw()

func _update_resources() -> void:
	var save = GameState.current_save
	label_corpses.text = "Corpses: " + str(save.meta_corpses)
	label_bone.text = "Bone Dust: " + str(save.meta_bone_dust)
	label_soul.text = "Souls: " + str(save.meta_soul_essence)

func _on_debug_grant() -> void:
	GameState.current_save.debug_grant_resources(1000)
	GameState.meta_resources_changed.emit()

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu/main_menu.tscn")
