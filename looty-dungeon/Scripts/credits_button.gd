extends TextureButton


func _on_pressed() -> void:
	await get_tree().create_timer(0.3).timeout
	get_tree().change_scene_to_file("res://Scenes/Credits.tscn")
