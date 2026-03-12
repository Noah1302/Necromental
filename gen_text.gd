extends SceneTree

func _init():
	print("Generating Dummy Tree via Text...")
	
	DirAccess.make_dir_absolute("res://data/upgrades")
	
	var nodes = [
		{"id": "upg_root", "title": "Heart of the Altar", "desc": "The central nexus of your necrotic power.", "pos": "(0, 0)", "tier": 0, "parents": [], "cost_c": 0, "cost_b": 0, "cost_s": 0},
		
		# Essence Path (Up)
		{"id": "upg_ess_1", "title": "Essence Gathering", "desc": "Increases base soul generation.", "pos": "(0, -180)", "tier": 1, "parents": ["upg_root"], "cost_c": 10, "cost_b": 0, "cost_s": 0},
		{"id": "upg_ess_2", "title": "Deeper Wells", "desc": "Expands maximum soul capacity.", "pos": "(-120, -320)", "tier": 2, "parents": ["upg_ess_1"], "cost_c": 25, "cost_b": 10, "cost_s": 0},
		{"id": "upg_ess_3", "title": "Soul Siphon", "desc": "Extract souls directly from enemies.", "pos": "(120, -320)", "tier": 2, "parents": ["upg_ess_1"], "cost_c": 30, "cost_b": 15, "cost_s": 5},
		{"id": "upg_ess_4", "title": "Void Tear", "desc": "Massive boost to all essence generation.", "pos": "(0, -480)", "tier": 3, "parents": ["upg_ess_2", "upg_ess_3"], "cost_c": 100, "cost_b": 50, "cost_s": 20},
		
		# Minion Path (Right)
		{"id": "upg_min_1", "title": "Bone Assembly", "desc": "Unlocks basic skeleton summoning.", "pos": "(180, 0)", "tier": 1, "parents": ["upg_root"], "cost_c": 15, "cost_b": 5, "cost_s": 0},
		{"id": "upg_min_2", "title": "Reinforced Marrow", "desc": "Skeletons have more health.", "pos": "(320, -120)", "tier": 2, "parents": ["upg_min_1"], "cost_c": 30, "cost_b": 20, "cost_s": 0},
		{"id": "upg_min_3", "title": "Horde Tactics", "desc": "Increase maximum skeleton cap.", "pos": "(320, 120)", "tier": 2, "parents": ["upg_min_1"], "cost_c": 40, "cost_b": 25, "cost_s": 0},
		{"id": "upg_min_4", "title": "Undead Lord", "desc": "Skeletons deal splash damage.", "pos": "(480, 0)", "tier": 3, "parents": ["upg_min_2", "upg_min_3"], "cost_c": 150, "cost_b": 100, "cost_s": 30},
		
		# Harvest Path (Left)
		{"id": "upg_harv_1", "title": "Scythe Sharpening", "desc": "Increase your own harvest damage.", "pos": "(-180, 0)", "tier": 1, "parents": ["upg_root"], "cost_c": 10, "cost_b": 5, "cost_s": 0},
		{"id": "upg_harv_2", "title": "Flesh Rending", "desc": "Chance to drop extra corpses.", "pos": "(-320, -120)", "tier": 2, "parents": ["upg_harv_1"], "cost_c": 20, "cost_b": 10, "cost_s": 0},
		{"id": "upg_harv_3", "title": "Bone Collector", "desc": "Chance to drop extra bone dust.", "pos": "(-320, 120)", "tier": 2, "parents": ["upg_harv_1"], "cost_c": 20, "cost_b": 10, "cost_s": 0},
		{"id": "upg_harv_4", "title": "Master Harvester", "desc": "Harvest yields are multiplied.", "pos": "(-480, 0)", "tier": 3, "parents": ["upg_harv_2", "upg_harv_3"], "cost_c": 100, "cost_b": 80, "cost_s": 25},
		
		# Rituals Path (Down)
		{"id": "upg_rit_1", "title": "Dark Chants", "desc": "Unlocks active rituals.", "pos": "(0, 180)", "tier": 1, "parents": ["upg_root"], "cost_c": 20, "cost_b": 10, "cost_s": 5},
		{"id": "upg_rit_2", "title": "Blood Sacrifice", "desc": "Sacrifice corpses for temporary power.", "pos": "(0, 320)", "tier": 2, "parents": ["upg_rit_1"], "cost_c": 50, "cost_b": 20, "cost_s": 10},
	]
	
	var template = """[gd_resource type="Resource" script_class="MetaUpgradeData" load_steps=2 format=3]

[ext_resource type="Script" path="res://src/data/meta_upgrade_data.gd" id="1_upg"]

[resource]
script = ExtResource("1_upg")
id = "{id}"
title = "{title}"
description = "{desc}"
category = "Essence"
tier = {tier}
max_level = 1
cost_corpses = {cost_c}
cost_bone_dust = {cost_b}
cost_soul_essence = {cost_s}
parent_ids = Array[String]({parents_str})
required_floor_id = ""
tree_position = Vector2{pos}
"""

	for n in nodes:
		var parents_str = ""
		if n.parents.size() > 0:
			var pts = []
			for p in n.parents:
				pts.append('"' + p + '"')
			parents_str = "[" + ", ".join(pts) + "]"
		else:
			parents_str = "[]"
			
		var content = template.replace("{id}", n.id).replace("{title}", n.title).replace("{desc}", n.desc).replace("{tier}", str(n.tier)).replace("{cost_c}", str(n.cost_c)).replace("{cost_b}", str(n.cost_b)).replace("{cost_s}", str(n.cost_s)).replace("{parents_str}", parents_str).replace("{pos}", n.pos)
		
		var f = FileAccess.open("res://data/upgrades/" + n.id + ".tres", FileAccess.WRITE)
		f.store_string(content)
		f.close()
		
	var dir = DirAccess.open("res://data/upgrades")
	if dir:
		dir.list_dir_begin()
		var count = 0
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tres"):
				count += 1
			file_name = dir.get_next()
		print("Generated " + str(count) + " files.")
	
	quit()
