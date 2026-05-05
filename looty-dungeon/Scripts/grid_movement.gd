class_name GridMovement
extends Node

@export var grid_size:float = 1
@export var step_time:float = 0.5
@export var bounce_back_time:float = 0.2

@export var body:Node3D
@export var rotate_speed:float

@export var ground_raycast:RayCast3D
var on_ground = false

@export_flags_3d_physics var enemy_collision
@export var exclude_colision:Array[CollisionObject3D]

@export_flags("slime") var inmune_to
var cur_effect:int = 0

var is_moving = false
signal finished_step()

signal on_wall
signal on_entity(node:Node3D)
signal on_bounce
signal remove_slime

var parent:Node3D
var hit_box: HitBox

var rot_tween: Tween
var mov_tween: Tween

var prev_pos:Vector3

func _ready() -> void:
	parent = get_parent() as Node3D
	
	for c in parent.get_children():
		if c is HitBox:
			hit_box = c
			break
	
	hit_box.area_entered.connect(on_hitbox_collide)

func _process(_delta: float) -> void:
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
	
	#if on slime -> attack
	if cur_effect == 1:
		remove_slime.emit()
		return
	
	#check walls or enemies
	var dir_3d = Vector3(dir.x,0,dir.y)
	var space = parent.get_world_3d().direct_space_state
	var wall_query = PhysicsRayQueryParameters3D.create(parent.position,parent.position+dir_3d,1)
	var result = space.intersect_ray(wall_query)
	if result:
		on_wall.emit()
		return
	
	#var enemy_query = PhysicsRayQueryParameters3D.create(parent.position,parent.position+dir_3d,enemy_collision) #TODO: review masks
	var enemy_query:PhysicsShapeQueryParameters3D = PhysicsShapeQueryParameters3D.new()
	enemy_query.collide_with_areas = true #Detectar hitboxes
	enemy_query.collide_with_bodies = false
	enemy_query.transform = parent.transform.translated(dir_3d*0.5)
	enemy_query.motion = Vector3.ZERO
	var shape_rid = PhysicsServer3D.box_shape_create()
	PhysicsServer3D.shape_set_data(shape_rid, Vector3(0.4,0.4,0.4) + abs(dir_3d*0.5))
	enemy_query.shape_rid = shape_rid
	enemy_query.collision_mask = enemy_collision
	var exclude = []
	for col in exclude_colision:
		exclude.append(col.get_rid())
	enemy_query.exclude = exclude
	result = space.intersect_shape(enemy_query)
	PhysicsServer3D.free_rid(shape_rid)
	if result:
		for coll in result:
			on_entity.emit(coll.collider.get_parent())
		return
	
	prev_pos = parent.position
	var new_pos = parent.position + Vector3(grid_size*dir.x,0,grid_size*dir.y)
	
	is_moving = true
	if mov_tween: mov_tween.kill()
	mov_tween = create_tween()
	mov_tween.set_ease(Tween.EASE_IN_OUT)
	mov_tween.tween_property(parent,"position",new_pos,step_time)
	mov_tween.chain().tween_callback(func(): is_moving = false)
	mov_tween.chain().tween_callback(func(): finished_step.emit())

func on_hitbox_collide(area:Area3D):
	if area is not HitBox: return
	if not (area as HitBox).bounce_on_coll: return
	mov_tween.kill()
	on_bounce.emit()
	var tween = get_tree().create_tween()
	tween.tween_property(parent,"position",prev_pos,bounce_back_time)
	await tween.finished
	is_moving = false
