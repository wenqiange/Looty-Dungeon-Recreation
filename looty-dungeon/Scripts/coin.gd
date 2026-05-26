extends Area3D

const ROTATE = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate_y(deg_to_rad(ROTATE))
	


	



func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("Player"):
		$CoinSound.play()
		queue_free()
