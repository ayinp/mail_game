extends Node
class_name LetterFactoryYay

var LetterScene := preload("res://scenes/objects/letter.tscn")


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


func get_letter_by_seal(seal_name: String) -> Variant:
	for letter in all_letters:
		if letter["seal_name"] == seal_name:
			return letter
	return null


func spawn_letter(data: Dictionary) -> Node:
	var letter = LetterScene.instantiate()
	letter.seal_name = data["seal_name"]
	letter.element = data["element"]
	letter.type = data["type"]
	if data.has("level"):
		letter.level = data["level"]

	# Add to scene
	get_node("/root/MainGame/LetterLayer").add_child(letter)
	letter.position = Vector2.ZERO

	# Bounce outward
	var angle = randf_range(0, TAU)  # TAU is 2π — full circle
	var distance = randf_range(100, 200)
	var target_pos = letter.position + Vector2.RIGHT.rotated(angle) * distance

	var tween = create_tween()
	tween.tween_property(letter, "position", target_pos, 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

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
	for letter in all_letters:
		if letter["seal_name"] == seal_name and letter["element"] == element and letter["type"] == type:
			return spawn_letter(letter)

	push_warning("No exact match for %s / %s / %s" % [seal_name, element, type])
	return null

	
	
func spawn_letter_from_set(allowed_seals: Array) -> Node:
	if allowed_seals.is_empty():
		push_warning("Tried to spawn letter from empty set!")
		return null

	# Choose one entry randomly
	var data = allowed_seals[randi() % allowed_seals.size()]

	# Support both full dictionaries or just seal_name strings
	if typeof(data) == TYPE_STRING:
		data = get_letter_by_seal(data)
		if data == null:
			push_warning("Seal not found in all_letters!")
			return null

	return spawn_letter(data)

