extends Node2D
const LetterScene = preload("res://scenes/objects/letter.tscn")


@onready var desk_loc: Vector2


func _ready():
	desk_loc = $".".global_position





