extends AudioStreamPlayer3D

@export var min_pitch:float
@export var max_pitch:float

func Play():
	pitch_scale = randf_range(min_pitch,max_pitch)
	play()
