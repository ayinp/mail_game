extends Node

signal day_over

var current_day := 1
var wave_delay := 30.0
var end_delay := 60.0

var focus_letter = {}
var waves = []
var rand_set = []
var current_wave = 0
var final_wave_spawned = false
var day_over_emitted = false

var day_data := {
	1: {
		"focus": { "seal_name": "Emberhold", "element": "fire", "type": "resolution" },
		"waves": [ { "focus": 4, "random": 0 } ],
		"randSet": []
	},
	2: {
		"focus": { "seal_name": "Murkdeep", "element": "water", "type": "movement" },
		"waves": [ { "focus": 2, "random": 2 }],
		"randSet": [{"seal_name": "Emberhold", "element": "fire", "type": "resolution"}]
	},
	3: {
		"focus": { "seal_name": "Bloomvale", "element": "earth", "type": "damaging" },
		"waves": [ { "focus": 3, "random": 2 } ],
		"randSet": [
			{"seal_name": "Emberhold", "element": "fire", "type": "resolution"},
			{"seal_name": "Murkdeep", "element": "water", "type": "movement"}
		]
	},
	4: {
		"focus": {},
		"waves": [{"focus": 0, "random": 6}],
		"randSet": [
			{"seal_name": "Emberhold", "element": "fire", "type": "resolution"},
			{"seal_name": "Murkdeep", "element": "water", "type": "movement"},
			{"seal_name": "Bloomvale", "element": "earth", "type": "damaging"}
		]
	}
	
}

func _process(_delta):
	if final_wave_spawned and not day_over_emitted:
		if not GameState.any_letters_remaining():
			_check_if_day_can_end()


func start_day():
	day_over_emitted = false
	final_wave_spawned = false
	var data = day_data.get(current_day)
	if data:
		print("🌅 Starting Day", current_day)
		waves = data["waves"].duplicate()
		focus_letter = data["focus"].duplicate()
		rand_set = data["randSet"].duplicate()
		current_wave = 0
		_spawn_wave()
	else:
		print("🚫 No day data found for day", current_day)
		emit_day_over()

func _spawn_wave():
	var wave = waves[current_wave]
	print("🌊 Wave", current_wave + 1, "of", waves.size(), "→", wave)

	for i in range(wave["focus"]):
		LetterFactory.spawn_letter_all(focus_letter["seal_name"], focus_letter["element"], focus_letter["type"])

	for i in range(wave["random"]):
		LetterFactory.spawn_letter_from_set(rand_set)

	current_wave += 1

	if current_wave < waves.size():
		await get_tree().create_timer(wave_delay).timeout
		_spawn_wave()
	else:
		final_wave_spawned = true
		_check_if_day_can_end()
		await get_tree().create_timer(end_delay).timeout
		_check_if_day_can_end(true)

func _check_if_day_can_end(force := false):
	if day_over_emitted:
		return
	if force or (final_wave_spawned and not GameState.any_letters_remaining()):
		emit_day_over()

func emit_day_over():
	if not day_over_emitted:
		day_over_emitted = true
		print("✅ Emitting day_over")
		emit_signal("day_over")
		current_day += 1
