class_name GridMovement
extends Node

@export var grid_size:float = 1
@export var step_time:float = 0.5

@export var body:Node3D
@export var rotate_speed:float

@export var ground_raycast:RayCast3D
var on_ground = false

@export_flags_3d_physics var enemy_collision

var is_moving = false
signal finished_step()

signal on_wall
signal on_entity

var parent:Node3D

var rot_tween: Tween

func _ready() -> void:
	parent = get_parent() as Node3D

func _process(delta: float) -> void:
	on_ground = ground_raycast.is_colliding()

func move(direction:global.direction):
	if is_moving: return
	var dir = global.dir_to_vec(direction)
	
	#rotate body
	var new_angle = (dir*Vector2(1,-1)).angle() + PI/2
	var angle_dif = angle_difference(body.rotation.y,new_angle)
	var new_rotation = Vector3(0,angle_dif,0)
	if rot_tween: rot_tween.kill()
	rot_tween = create_tween()
	rot_tween.set_ease(Tween.EASE_IN_OUT)
	rot_tween.tween_property(body,"rotation",new_rotation,abs(angle_dif)/rotate_speed).as_relative()
	
	#check walls or enemies
	var dir_3d = Vector3(dir.x,0,dir.y)
	var space = parent.get_world_3d().direct_space_state
	
	var wall_query = PhysicsRayQueryParameters3D.create(parent.position,parent.position+dir_3d,1)
	var result = space.intersect_ray(wall_query)
	if result:
		on_wall.emit()
		return
	
	var enemy_query = PhysicsRayQueryParameters3D.create(parent.position,parent.position+dir_3d,enemy_collision) #TODO: review masks
	enemy_query.collide_with_areas = true #Detectar hitboxes
	enemy_query.collide_with_bodies = false
	result = space.intersect_ray(enemy_query)
	if result:
		on_entity.emit()
		return
	
	var new_pos = parent.position + Vector3(grid_size*dir.x,0,grid_size*dir.y)
	
	is_moving = true
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(parent,"position",new_pos,step_time)
	await tween.finished
	
	is_moving = false
	finished_step.emit()
