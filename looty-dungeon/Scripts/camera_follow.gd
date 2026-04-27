extends Camera3D

@export var off_set:Vector3
@export var follow:Node3D

@export var min_x:float
@export var max_x:float

var ini_offset:Vector3

func _ready() -> void:
	reset_ini_offset()

func _process(_delta: float) -> void:
	var new_pos = follow.position + ini_offset + off_set
	new_pos.x = clamp(new_pos.x,min_x,max_x)
	position = position.lerp(new_pos,0.1)

func reset_ini_offset():
	ini_offset = position - follow.position
