extends TextureButton


@onready var fade_transition: FadeTransition = $"../../fade_transition"

func _on_pressed() -> void:
	await fade_transition.fade_in()
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
