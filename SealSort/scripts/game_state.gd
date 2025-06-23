extends Node
class_name GameStateManager

var score: int = 0
var total_letters_sorted: int = 0
var correct_letters_sorted: int = 0

func reset_day():
	score = 0.0
	total_letters_sorted = 0

func register_letter_sort(letter: Letter, misfiled_factor: float):
	var base_score = get_letter_base_score(letter)
	var health_factor = clamp(letter.health, 0.0, 1.0)  # assume 1.0 is full health
	var day_score = round(base_score * misfiled_factor * health_factor)
	
	score += day_score
	total_letters_sorted += 1
	if(misfiled_factor == 1):
		correct_letters_sorted += 1

	print("📬 Sorted:", letter.seal_name, "→ +", day_score, "pts (total:", score, ")")

func get_letter_base_score(letter: Letter) -> float:
	match letter.level:
		1: return 3.0
		2: return 6.0
		3: return 9.0
		4: return 12.0
	return 0


func any_letters_remaining() -> bool:
	return not get_tree().get_nodes_in_group("letters").is_empty()

