extends TextureButton


func _on_pressed() -> void:
	await get_tree().create_timer(0.3).timeout
	get_tree().quit()
