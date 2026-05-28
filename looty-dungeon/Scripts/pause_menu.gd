extends ColorRect

var paused = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if not paused: pause_game()
		else: unpause_game()

func pause_game():
	paused = true
	get_tree().paused = true
	show()

func unpause_game():
	paused = false
	get_tree().paused = false
	hide()
