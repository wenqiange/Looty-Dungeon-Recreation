extends AudioStreamPlayer2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	(get_parent() as TextureButton).mouse_entered.connect(play)
