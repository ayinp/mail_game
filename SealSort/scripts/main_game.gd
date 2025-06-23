extends Node2D

@onready var camera := $Camera2D

var deskLoc: Vector2
var drawerLoc: Vector2
var leftLoc: Vector2
var rightLoc: Vector2

func _ready():
	deskLoc = $DeskView.global_position
	drawerLoc = $DrawerView.global_position
	leftLoc = $LeftView.global_position
	rightLoc = $RightView.global_position
	
	var desk_scene = preload("res://scenes/screens/desk_screen.tscn")
	var desk = desk_scene.instantiate()
	$DeskView.add_child(desk)
	var drawers_scene = preload("res://scenes/screens/drawers_screen.tscn")
	var drawers = drawers_scene.instantiate()
	$DrawerView.add_child(drawers)
	var left_scene = preload("res://scenes/screens/left_screen.tscn")
	var left = left_scene.instantiate()
	$LeftView.add_child(left)
	var right_scene = preload("res://scenes/screens/right_screen.tscn")
	var right = right_scene.instantiate()
	$RightView.add_child(right)
	

func move_camera_to(position: Vector2):
	var tween = create_tween()
	tween.tween_property(camera, "position", position, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func go_up():
	if (camera.global_position == deskLoc):
		move_camera_to(drawerLoc)

func go_down():
	if (camera.global_position == drawerLoc):
		move_camera_to(deskLoc)

func go_left():
	if (camera.global_position == deskLoc):
		move_camera_to(leftLoc)
	elif (camera.global_position == rightLoc):
		move_camera_to(deskLoc)

func go_right():
	if (camera.global_position == deskLoc):
		move_camera_to(rightLoc)
	elif (camera.global_position == leftLoc):
		move_camera_to(deskLoc)

func _input(event):
	if event.is_action_pressed("ui_up"):
		go_up()
	elif event.is_action_pressed("ui_down"):
		go_down()
	elif event.is_action_pressed("ui_left"):
		go_left()
	elif event.is_action_pressed("ui_right"):
		go_right()

