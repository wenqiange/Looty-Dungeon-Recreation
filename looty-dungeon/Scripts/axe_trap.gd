extends AnimatableBody3D


func _ready():
	rotar_loop()

func rotar_loop():
	var tween = create_tween()
	
	tween.tween_property(
		self,
		"rotation_degrees:y",
		rotation_degrees.y + 90,
		1.0
	)
	
	tween.tween_interval(1.0) 
	
	tween.finished.connect(rotar_loop)
