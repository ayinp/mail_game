extends Node2D
const LetterScene = preload("res://scenes/objects/letter.tscn")


@onready var desk_loc: Vector2


func _ready():
	desk_loc = $".".global_position
	spawn_random_letter();

var all_letters = [
	{"seal_name": "Emberhold", "element": "fire", "type": "resolution"},
	{"seal_name": "Ashenspire", "element": "fire", "type": "damaging"},
	{"seal_name": "Infernia", "element": "fire", "type": "movement"},
	{"seal_name": "Tidewatch", "element": "water", "type": "damaging"},
	{"seal_name": "Glacialis", "element": "water", "type": "resolution"},
	{"seal_name": "Murkdeep", "element": "water", "type": "movement"},
	{"seal_name": "Bloomvale", "element": "earth", "type": "damaging"},
	{"seal_name": "Burrowend", "element": "earth", "type": "resolution"},
	{"seal_name": "Stonebarrow", "element": "earth", "type": "movement"},
	{"seal_name": "Galeholt", "element": "air", "type": "damaging"},
	{"seal_name": "Whispermere", "element": "air", "type": "resolution"},
	{"seal_name": "Skyrise", "element": "air", "type": "movement"},
	{"seal_name": "Clockmere", "element": "special", "type": "movement"},
	{"seal_name": "Dreamveil", "element": "special", "type": "resolution"},
	{"seal_name": "Hollowreach", "element": "special", "type": "damaging"}
]


func spawn_letter(data: Dictionary):
	var letter = LetterScene.instantiate()
	letter.seal_name = data["seal_name"]
	letter.element = data["element"]
	letter.type = data["type"]
	get_node("/root/MainGame/LetterLayer").add_child(letter)
	letter.position = $letterSpawn.global_position
	return letter


func spawn_random_letter():
	var pick = all_letters[randi() % all_letters.size()]
	return spawn_letter(pick)

func spawn_letter_element(element: String):
	var filtered = all_letters.filter(func(l): return l["element"] == element)
	if filtered.size() == 0:
		push_warning("No letters with element: %s" % element)
		return null
	return spawn_letter(filtered[randi() % filtered.size()])

func spawn_letter_type(type: String):
	var filtered = all_letters.filter(func(l): return l["type"] == type)
	if filtered.size() == 0:
		push_warning("No letters with type: %s" % type)
		return null
	return spawn_letter(filtered[randi() % filtered.size()])

func spawn_letter_element_type(element: String, type: String):
	var filtered = all_letters.filter(func(l): return l["element"] == element and l["type"] == type)
	if filtered.size() == 0:
		push_warning("No letters with element %s and type %s" % [element, type])
		return null
	return spawn_letter(filtered[randi() % filtered.size()])

func spawn_letter_all(seal_name: String, element: String, type: String):
	var exact = all_letters.find(func(l): return l["seal_name"] == seal_name and l["element"] == element and l["type"] == type)
	if exact == null:
		push_warning("No exact match for %s / %s / %s" % [seal_name, element, type])
		return null
	return spawn_letter(exact)



