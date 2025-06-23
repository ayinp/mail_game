extends Control
signal start_next_day_pressed

@onready var score_label = $CenterContainer/VBoxContainer/ScoreLabel
@onready var total_sorted_label = $CenterContainer/VBoxContainer/TotalSortedLabel
@onready var correct_sorted_label = $CenterContainer/VBoxContainer/CorrectSortedLabel
@onready var start_button = $CenterContainer/VBoxContainer/NextDay

func _ready():
	hide()
	start_button.pressed.connect(_on_start_button_pressed)

func update_results(score: int, letters_sorted: int, correct_sorted: int):
	score_label.text = "Score: %d" % score
	total_sorted_label.text = "Total Letters Sorted: %d" % letters_sorted
	correct_sorted_label.text = "Letters Sorted Correctly: %d" % correct_sorted

func _on_start_button_pressed():
	emit_signal("start_next_day_pressed")


