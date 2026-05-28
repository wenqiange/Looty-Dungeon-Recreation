class_name FadeTransition
extends ColorRect

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func fade_in():
	show()
	animation_player.play("fade_in")
	await animation_player.animation_finished

func fade_out():
	animation_player.play("fade_out")
	await animation_player.animation_finished
	hide()
