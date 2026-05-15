class_name CameraFollow
extends Camera3D

@export var off_set:Vector3
@export var follow:Node3D

@export var min_x:float
@export var max_x:float

@export var lock:bool
var lock_position:Vector3

var ini_offset:Vector3

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	var new_pos = Vector3.ZERO
	if lock:  new_pos = lock_position + off_set
	else: new_pos = follow.position + off_set
	new_pos.x = clamp(new_pos.x,min_x,max_x)
	position = position.lerp(new_pos,0.1)
