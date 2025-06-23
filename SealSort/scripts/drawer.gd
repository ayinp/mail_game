extends Area2D

@onready var sprite = $Sprite

@export var seal_name: String
@export var element: String
@export var type: String

func _ready():
	sprite.modulate = get_drawer_color(element, type)

# Called by Letter when dropped on top
# Called by Letter when dropped on top
func handle_dropped_letter(letter):
	var misfiled := 1.0  # Default: correct

	
	if letter.seal_name == seal_name && letter.solvedState == true:
		print("here2")
		misfiled = 1.0
	elif letter.seal_name == seal_name && letter.solvedState == false:
		print("here2")
		misfiled = 0.33
	elif letter.element == element && letter.solvedState == true:
		print("here3")
		misfiled = 0.66
	elif letter.seal_name != seal_name && letter.solvedState == false:
		print("here4")
		misfiled = 0
	elif letter.element != element:
		print("here5")
		misfiled = 0
	else:
		print("here6")
		misfiled = 0.0

	GameState.register_letter_sort(letter, misfiled)

	if misfiled == 1.0:
		print("✅ Correct drawer!")
		letter.queue_free()  # ✨ Remove the letter from the scene
	else:
		print("❌ Misfiled (x" + str(misfiled) + ")")
		letter.queue_free()  # ✨ Remove the letter from the scene


func get_drawer_color(element: String, type: String) -> Color:
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
