extends ColorRect

func on_death():
	show()
	$GameOver.play()
#	await $GameOver.finished
	get_tree().paused = true


func revive() -> void:
	hide()
	get_tree().paused = false
