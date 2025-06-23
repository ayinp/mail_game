extends Node2D

@onready var camera := $Camera2D

var deskLoc: Vector2
var drawerLoc: Vector2
var leftLoc: Vector2
var rightLoc: Vector2

var day_manager_scene := preload("res://scenes/day_manager.tscn")
var end_screen_scene := preload("res://scenes/screens/end_screen.tscn")

var day_manager = null
var end_screen = null

func _ready():
	# Store camera positions
	deskLoc = $DeskView.global_position
	drawerLoc = $DrawerView.global_position
	leftLoc = $LeftView.global_position
	rightLoc = $RightView.global_position

	# Load screen scenes
	var desk_scene = preload("res://scenes/screens/desk_screen.tscn").instantiate()
	$DeskView.add_child(desk_scene)

	var drawers_scene = preload("res://scenes/screens/drawers_screen.tscn").instantiate()
	$DrawerView.add_child(drawers_scene)

	var left_scene = preload("res://scenes/screens/left_screen.tscn").instantiate()
	$LeftView.add_child(left_scene)

	var right_scene = preload("res://scenes/screens/right_screen.tscn").instantiate()
	$RightView.add_child(right_scene)

	# Set up DayManager
	day_manager = day_manager_scene.instantiate()
	add_child(day_manager)
	day_manager.connect("day_over", Callable(self, "_on_day_over"))

	# Set up End Screen
	end_screen = end_screen_scene.instantiate()
	add_child(end_screen)
	end_screen.connect("start_next_day_pressed", Callable(self, "_on_start_next_day_pressed"))
	end_screen.hide()

	# Start the first day
	day_manager.start_day()


func _on_day_over():
	print("🏁 Day is over!")
	move_camera_to(deskLoc)  # ⬅️ Snap back to desk screen!
	end_screen.update_results(GameState.score, GameState.total_letters_sorted, GameState.correct_letters_sorted)
	end_screen.show()


func _on_start_next_day_pressed():
	end_screen.hide()
	day_manager.start_day()

# ------------------ Camera Controls ------------------

func move_camera_to(position: Vector2):
	var tween = create_tween()
	tween.tween_property(camera, "position", position, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func go_up():
	if camera.global_position == deskLoc:
		move_camera_to(drawerLoc)

func go_down():
	if camera.global_position == drawerLoc:
		move_camera_to(deskLoc)

func go_left():
	if camera.global_position == deskLoc:
		move_camera_to(leftLoc)
	elif camera.global_position == rightLoc:
		move_camera_to(deskLoc)

func go_right():
	if camera.global_position == deskLoc:
		move_camera_to(rightLoc)
	elif camera.global_position == leftLoc:
		move_camera_to(deskLoc)

func _input(event):
	if end_screen.visible:
		return  # 🚫 Block camera movement when end screen is visible

	if event.is_action_pressed("ui_up"):
		go_up()
	elif event.is_action_pressed("ui_down"):
		go_down()
	elif event.is_action_pressed("ui_left"):
		go_left()
	elif event.is_action_pressed("ui_right"):
		go_right()

