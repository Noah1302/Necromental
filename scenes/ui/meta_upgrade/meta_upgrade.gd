extends Control

const UPGRADE_CARD_SCENE = preload("res://scenes/ui/meta_upgrade/upgrade_card.tscn")
const UPGRADES_PATH = "res://data/upgrades/"

@onready var label_corpses: Label = %CorpsesLabel
@onready var label_bone: Label = %BoneDustLabel
@onready var label_soul: Label = %SoulLabel

@onready var category_container: VBoxContainer = %CategoryContainer
@onready var upgrade_grid: GridContainer = %UpgradeGrid

@onready var detail_title: Label = %DetailTitle
@onready var detail_desc: Label = %DetailDesc
@onready var detail_req: Label = %DetailReq
@onready var detail_cost: Label = %DetailCost
@onready var btn_purchase: Button = %BtnPurchase

@onready var btn_back: Button = %BackBtn
@onready var btn_debug: Button = %DebugGrantBtn

var all_upgrades: Array[MetaUpgradeData] = []
var selected_upgrade: MetaUpgradeData
var active_card: Control
var current_category: String = "Essence"

var categories: Array[String] = ["Essence", "Minions", "Harvest", "Command", "Core", "Rituals"]

func _ready() -> void:
	btn_back.pressed.connect(_on_back_pressed)
	btn_debug.pressed.connect(_on_debug_grant)
	btn_purchase.pressed.connect(_on_purchase_pressed)
	
	GameState.meta_resources_changed.connect(_on_resources_changed)
	
	_load_upgrades()
	_setup_category_tabs()
	_build_grid(current_category)
	
	_update_resources()
	_clear_details()
	
	btn_back.grab_focus()

func _load_upgrades() -> void:
	all_upgrades.clear()
	var dir = DirAccess.open(UPGRADES_PATH)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".tres"):
				var res = ResourceLoader.load(UPGRADES_PATH + file_name) as MetaUpgradeData
				if res:
					all_upgrades.append(res)
			file_name = dir.get_next()

func _setup_category_tabs() -> void:
	for child in category_container.get_children():
		child.queue_free()
		
	for cat in categories:
		var btn = Button.new()
		btn.text = cat
		btn.custom_minimum_size = Vector2(0, 40)
		btn.theme_override_font_sizes.font_size = 18
		
		var normal_style = StyleBoxFlat.new()
		normal_style.bg_color = Color(0.15, 0.15, 0.2)
		normal_style.border_width_left = 2
		normal_style.border_color = Color(0.3, 0.2, 0.4)
		
		# If it's the current one
		var active_style = StyleBoxFlat.new()
		active_style.bg_color = Color(0.25, 0.2, 0.35)
		active_style.border_width_left = 4
		active_style.border_color = Color(0.65, 0.35, 0.9)
		
		if cat == current_category:
			btn.add_theme_stylebox_override("normal", active_style)
			btn.add_theme_stylebox_override("hover", active_style)
		else:
			btn.add_theme_stylebox_override("normal", normal_style)
			
		btn.pressed.connect(func(): _on_category_selected(cat))
		category_container.add_child(btn)

func _on_category_selected(cat: String) -> void:
	current_category = cat
	_setup_category_tabs() # Refresh visual selection
	_build_grid(current_category)

func _build_grid(cat: String) -> void:
	for child in upgrade_grid.get_children():
		child.queue_free()
		
	var filtered = all_upgrades.filter(func(u: MetaUpgradeData): return u.category == cat)
	filtered.sort_custom(func(a, b): return a.tier < b.tier) # Sort by tier
	
	for upg in filtered:
		var card = UPGRADE_CARD_SCENE.instantiate()
		card.setup(upg)
		card.card_selected.connect(_on_card_selected)
		card.card_clicked.connect(func(d): _on_card_selected(d, card); btn_purchase.grab_focus())
		upgrade_grid.add_child(card)

func _on_card_selected(data: MetaUpgradeData, card: Control) -> void:
	if active_card and is_instance_valid(active_card) and active_card.has_method("set_active"):
		active_card.set_active(false)
		
	active_card = card
	selected_upgrade = data
	if active_card.has_method("set_active"):
		active_card.set_active(true)
	
	_populate_details(data)

func _populate_details(data: MetaUpgradeData) -> void:
	detail_title.text = data.title
	detail_desc.text = data.description
	
	var c_col = "[color=#aadd8c]" + str(data.cost_corpses) + " Corpses[/color]" if data.cost_corpses > 0 else ""
	var b_col = "[color=#d1c48c]" + str(data.cost_bone_dust) + " Bone[/color]" if data.cost_bone_dust > 0 else ""
	var s_col = "[color=#68d2dd]" + str(data.cost_soul_essence) + " Souls[/color]" if data.cost_soul_essence > 0 else ""
	
	var cost_arr = []
	if c_col != "": cost_arr.append(c_col)
	if b_col != "": cost_arr.append(b_col)
	if s_col != "": cost_arr.append(s_col)
	
	# RichTextLabel workaround by just making cost a multiline string for now, but we use label so let's use plain text
	var plain_cost = ""
	if data.cost_corpses > 0: plain_cost += str(data.cost_corpses) + " Corpses\n"
	if data.cost_bone_dust > 0: plain_cost += str(data.cost_bone_dust) + " Bone Dust\n"
	if data.cost_soul_essence > 0: plain_cost += str(data.cost_soul_essence) + " Souls\n"
	
	detail_cost.text = "Cost:\n" + plain_cost
	
	detail_req.text = ""
	if data.required_upgrade_id != "":
		detail_req.text = "Requires: " + data.required_upgrade_id
	if data.required_floor_id != "":
		detail_req.text = "Requires Floor: " + data.required_floor_id
		
	if data.is_locked():
		btn_purchase.disabled = true
		btn_purchase.text = "LOCKED"
	elif data.is_purchased():
		btn_purchase.disabled = true
		btn_purchase.text = "MAXED / PURCHASED"
	elif data.can_afford():
		btn_purchase.disabled = false
		btn_purchase.text = "PURCHASE"
	else:
		btn_purchase.disabled = true
		btn_purchase.text = "NOT ENOUGH RESOURCES"

func _clear_details() -> void:
	detail_title.text = "Select an Upgrade"
	detail_desc.text = "Hover or focus an upgrade node to see its details and costs."
	detail_cost.text = ""
	detail_req.text = ""
	btn_purchase.disabled = true
	btn_purchase.text = ""
	active_card = null
	selected_upgrade = null

func _on_purchase_pressed() -> void:
	if selected_upgrade and not selected_upgrade.is_purchased() and selected_upgrade.can_afford():
		if GameState.purchase_upgrade(selected_upgrade.id, selected_upgrade.cost_corpses, selected_upgrade.cost_bone_dust, selected_upgrade.cost_soul_essence):
			if cache_upg:
				for c in upgrade_grid.get_children():
					if c.data.id == cache_upg.id:
						_on_card_selected(cache_upg, c)
						btn_purchase.grab_focus()

func _on_resources_changed() -> void:
	_update_resources()
	if selected_upgrade:
		_populate_details(selected_upgrade)
	# Refresh grid to update available states
	if upgrade_grid.get_child_count() > 0:
		for c in upgrade_grid.get_children():
			c._update_visuals()

func _update_resources() -> void:
	var save = GameState.current_save
	label_corpses.text = "Corpses: " + str(save.meta_corpses)
	label_bone.text = "Bone Dust: " + str(save.meta_bone_dust)
	label_soul.text = "Souls: " + str(save.meta_soul_essence)

func _on_debug_grant() -> void:
	GameState.current_save.debug_grant_resources(50)
	GameState.meta_resources_changed.emit()

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu/main_menu.tscn")
