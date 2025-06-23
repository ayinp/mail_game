extends Area2D
class_name Letter

@onready var sprite = $Sprite

@export var seal_name: String
@export var element: String
@export var type: String
@export var level: int
@export var health: float = 1
@export var solvedState: bool = true
var is_sorted = false

var dragging := false
var drag_offset := Vector2.ZERO


func _ready():
	sprite.modulate = get_letter_color(element, type)
	monitoring = true  # Needed for get_overlapping_areas()
	level = determineLetterLevel(seal_name)
	solvedState = determineLetterState(type)
	add_to_group("letters")

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Only respond if this is the topmost letter under the mouse
		var top_letter = get_topmost_letter_at_mouse()
		if top_letter == self:
			dragging = true
			drag_offset = position - get_global_mouse_position()

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		if dragging:
			print("🛑 Dropped letter")
			check_for_drawer()
		dragging = false

func _process(delta):
	if dragging:
		position = get_global_mouse_position() + drag_offset

func check_for_drawer():
	for area in get_overlapping_areas():
		if area.has_method("handle_dropped_letter"):
			area.handle_dropped_letter(self)

func get_letter_color(element: String, type: String) -> Color:
	match element:
		"fire":
			match type:
				"damaging": return Color.html("8B1A1A")    # Ashenspire (Lvl 3)
				"resolution": return Color.html("FFB3A7")  # Emberhold (Lvl 1)
				"movement": return Color.html("E34234")    # Infernia (Lvl 2)
		"water":
			match type:
				"damaging": return Color.html("3EB4C8")    # Tidewatch (Lvl 2)
				"resolution": return Color.html("005F73")  # Glacialis (Lvl 3)
				"movement": return Color.html("A4DDED")    # Murkdeep (Lvl 1)
		"earth":
			match type:
				"damaging": return Color.html("AED581")    # Bloomvale (Lvl 1)
				"resolution": return Color.html("689F38")  # Burrowend (Lvl 2)
				"movement": return Color.html("2E7D32")    # Stonebarrow (Lvl 3)
		"air":
			match type:
				"damaging": return Color.html("E1BEE7")    # Galeholt (Lvl 1)
				"resolution": return Color.html("BA68C8")  # Whispermere (Lvl 2)
				"movement": return Color.html("6A1B9A")    # Skyrise (Lvl 3)
		"special":
			match type:
				"damaging": return Color.html("FFEE58")    # Hollowreach (Lvl 4)
				"resolution": return Color.html("FFF176")  # Dreamveil (Lvl 4)
				"movement": return Color.html("FBC02D")    # Clockmere (Lvl 4)
	return Color.WHITE

func determineLetterLevel(seal_name:String):
	match seal_name:
		"Ashenspire": return 3
		"Emberhold": return 1
		"Infernia": return 2
		"Tidewatch": return 2
		"Glacialis": return 3
		"Murkdeep": return 1
		"Bloomvale": return 1
		"Burrowend": return 2
		"Stonebarrow": return 3
		"Galeholt": return 1
		"Whispermere": return 2
		"Skyrise": return 3
		"Hollowreach": return 4
		"Dreamveil": return 4
		"Clockmere": return 4


func determineLetterState(type: String):
	match type:
		"damaging": return true
		"resolution": return false
		"movement": return true

func get_topmost_letter_at_mouse() -> Node:
	var mouse_pos = get_global_mouse_position()
	var candidates := []

	for letter in get_tree().get_nodes_in_group("letters"):
		if letter is Letter and letter.sprite:
			var tex_size = letter.sprite.texture.get_size() * letter.sprite.scale
			var top_left = letter.global_position - tex_size / 2
			var rect = Rect2(top_left, tex_size)
			if rect.has_point(mouse_pos):
				candidates.append(letter)

	if candidates.is_empty():
		return null

	candidates.sort_custom(func(a, b): return a.z_index > b.z_index)
	return candidates[0]
