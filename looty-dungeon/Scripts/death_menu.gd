extends ColorRect

func on_death():
	show()
	get_tree().paused = true


func revive() -> void:
	hide()
	get_tree().paused = false
