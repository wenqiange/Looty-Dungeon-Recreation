extends StaticBody3D


func _on_end_trigger_area_entered(_area: Area3D) -> void:
	(get_parent() as Level).finished()
