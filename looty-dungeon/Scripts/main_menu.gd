extends Control

var button_type = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	button_type = "start"
	$Button_manager/PressSound.play()
	$fade_transition.show()
	$fade_transition/Timer.start()
	$fade_transition/AnimationPlayer.play("fade_in")

func _on_credits_pressed() -> void:
	$Button_manager/PressSound.play()
	await $Button_manager/PressSound.finished
	get_tree().change_scene_to_file("res://Scenes/Credits.tscn")


func _on_quit_pressed() -> void:
	$Button_manager/PressSound.play()
	await $Button_manager/PressSound.finished
	get_tree().quit()


func _on_timer_timeout() -> void:
	if button_type == "start":
		get_tree().change_scene_to_file("res://Scenes/game.tscn")


func _on_start_mouse_entered() -> void:
	$Button_manager/HoverSound.play()


func _on_credits_mouse_entered() -> void:
	$Button_manager/HoverSound.play()


func _on_quit_mouse_entered() -> void:
	$Button_manager/HoverSound.play()
