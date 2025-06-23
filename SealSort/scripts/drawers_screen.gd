extends Node2D
const DrawerScene = preload("res://scenes/objects/drawer.tscn")

const DRAWER_WIDTH = 360
const DRAWER_HEIGHT = 104
const SCREEN_WIDTH = 1280
const SCREEN_HEIGHT = 720
const COLUMNS = 3

func _ready():
	spawn_drawers_sorted()


var drawer_data = [
	{"seal": "Galeholt", "element": "air", "type": "damaging", "level": 1},
	{"seal": "Whispermere", "element": "air", "type": "resolution", "level": 2},
	{"seal": "Skyrise", "element": "air", "type": "movement", "level": 3},
	{"seal": "Bloomvale", "element": "earth", "type": "damaging", "level": 1},
	{"seal": "Burrowend", "element": "earth", "type": "resolution", "level": 2},
	{"seal": "Stonebarrow", "element": "earth", "type": "movement", "level": 3},
	{"seal": "Ashenspire", "element": "fire", "type": "damaging", "level": 3},
	{"seal": "Emberhold", "element": "fire", "type": "resolution", "level": 1},
	{"seal": "Infernia", "element": "fire", "type": "movement", "level": 2},
	{"seal": "Tidewatch", "element": "water", "type": "damaging", "level": 2},
	{"seal": "Glacialis", "element": "water", "type": "resolution", "level": 3},
	{"seal": "Murkdeep", "element": "water", "type": "movement", "level": 1},
	{"seal": "Hollowreach", "element": "special", "type": "damaging", "level": 4},
	{"seal": "Dreamveil", "element": "special", "type": "resolution", "level": 4},
	{"seal": "Clockmere", "element": "special", "type": "movement", "level": 4}
]

func spawn_drawers_sorted():
	var grouped := {
		"fire": [],
		"water": [],
		"earth": [],
		"air": [],
		"special": []
	}

	for drawer in drawer_data:
		grouped[drawer.element].append(drawer)

	# Sort each group by level
	for key in grouped.keys():
		grouped[key].sort_custom(func(a, b): return a["level"] < b["level"])

	var col_spacing = DRAWER_WIDTH + 20
	var row_spacing = DRAWER_HEIGHT + 20

	var total_grid_width = (COLUMNS - 1) * col_spacing
	var start_x = -total_grid_width / 2
	var start_y = -2 * row_spacing  # centers all 5 rows on screen

	var element_order = ["fire", "water", "earth", "air", "special"]

	for row in range(element_order.size()):
		var element = element_order[row]
		for col in range(grouped[element].size()):
			var drawer_info = grouped[element][col]
			var pos = Vector2(
				start_x + col * col_spacing,
				start_y + row * row_spacing
			)

			var drawer = DrawerScene.instantiate()
			drawer.seal_name = drawer_info["seal"]
			drawer.element = drawer_info["element"]
			drawer.type = drawer_info["type"]
			drawer.position = pos
			add_child(drawer)
