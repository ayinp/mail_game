extends Area2D
class_name Letter

@onready var sprite = $Sprite

@export var seal_name: String
@export var element: String
@export var type: String
var is_sorted = false

var dragging := false
var drag_offset := Vector2.ZERO

func _ready():
	sprite.modulate = get_letter_color(element, type)
	monitoring = true  # Needed for get_overlapping_areas()

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
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
				"damaging": return Color.html("C62828") 
				"resolution": return Color.html("EF5350") 
				"movement": return Color.html("FF8A80") 
		"water":
			match type:
				"damaging": return Color.html("00897B") 
				"resolution": return Color.html("00CFC1") 
				"movement": return Color.html("A7E3F4") 
		"earth":
			match type:
				"damaging": return Color.html("388E3C") 
				"resolution": return Color.html("81C784") 
				"movement": return Color.html("C8E6C9") 
		"air":
			match type:
				"damaging": return Color.html("5E35B1") 
				"resolution": return Color.html("9575CD") 
				"movement": return Color.html("D1C4E9") 
		"special":
			match type:
				"damaging": return Color.html("FDD835") 
				"resolution": return Color.html("FFF176") 
				"movement": return Color.html("FFF9C4") 
	return Color.WHITE
