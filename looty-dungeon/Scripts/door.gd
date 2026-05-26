extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	(get_parent() as Level).no_enemies.connect(open)


func open():
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(self,"position",Vector3.DOWN*1.7,2).as_relative()
	await tween.finished
