class_name GridMovement
extends Node

@export var grid_size:float = 1
@export var step_time:float = 0.5

var is_moving = false
signal finished_step()

var parent:Node3D

func _ready() -> void:
	parent = get_parent() as Node3D

func move(direction:global.direction):
	if is_moving: return
	var dir = global.dir_to_vec(direction)
	var new_pos = parent.position + Vector3(grid_size*dir.x,0,grid_size*dir.y)
	
	is_moving = true
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(parent,"position",new_pos,step_time)
	await tween.finished
	
	is_moving = false
	finished_step.emit()
