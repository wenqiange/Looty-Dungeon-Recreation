extends Button

@export var next_scene:PackedScene
@export var fade:FadeTransition
@export var UI:Control

func _on_pressed() -> void:
	UI.hide()
	if fade:
		await fade.fade_in()
	get_tree().paused = false
	get_tree().change_scene_to_packed(next_scene)
