extends Area2D

@onready var sprite = $Sprite

@export var seal_name: String
@export var element: String
@export var type: String

func _ready():
	sprite.modulate = get_drawer_color(element, type)

# Called by Letter when dropped on top
func handle_dropped_letter(letter):
	if letter.seal_name == seal_name:
		print("✅ Correct drawer!")
		letter.is_sorted = true
	else:
		print("❌ Wrong drawer!")

func get_drawer_color(element: String, type: String) -> Color:
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
