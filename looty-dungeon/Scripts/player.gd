extends Node3D

@onready var grid_movement: GridMovement = $GridMovement
@onready var step_timer: Timer = $Step_timer
@onready var body: Node3D = $Body
@onready var ground_check: RayCast3D = $GroundCheck
@onready var health: Health = $Health
@onready var invincibility_timer: Timer = $"Invincibility timer"
@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var attack_timer: Timer = $"Attack timer"

@export var rotate_speed:float

@export_flags_3d_physics var enemy_collision

@export var Attack_animation:String
@export var Action_animation:String

var can_move:bool = true
var on_ground:bool = true

var just_attacked:bool = false

var tween: Tween

func _ready() -> void:	
	invincibility_timer.timeout.connect(end_invincibility)
	
	health.got_hit.connect(on_hit)
	health.death.connect(die)
	
	animator.play("Basic/Idle")

func _process(delta: float) -> void:
	on_ground = ground_check.is_colliding()

func _physics_process(_delta: float) -> void:
	if can_move:
		#check direction
		if grid_movement.is_moving or step_timer.time_left > 0: return
		var dir = Vector2(Input.get_axis("move_right","move_left"),Input.get_axis("move_down","move_up"))
		if dir.length() <= 0: 
			animator.play("Basic/Idle")
			just_attacked = false
			return
		var direction = global.vec_to_dir(dir)
		dir = global.dir_to_vec(direction) #No diagonales
		
		#rotate body
		var new_angle = (dir*Vector2(1,-1)).angle() + PI/2
		var angle_dif = angle_difference(body.rotation.y,new_angle)
		var new_rotation = Vector3(0,angle_dif,0)
		if tween: tween.kill()
		tween = create_tween()
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(body,"rotation",new_rotation,abs(angle_dif)/rotate_speed).as_relative()
		
		#check walls or enemies
		var dir_3d = Vector3(dir.x,0,dir.y)
		var space = get_world_3d().direct_space_state
		
		var wall_query = PhysicsRayQueryParameters3D.create(position,position+dir_3d,1)
		var result = space.intersect_ray(wall_query)
		if result:
			#TODO: Wall animation
			return
		
		var enemy_query = PhysicsRayQueryParameters3D.create(position,position+dir_3d,enemy_collision) #TODO: review masks
		enemy_query.collide_with_areas = true #Detectar hitboxes
		enemy_query.collide_with_bodies = false
		result = space.intersect_ray(enemy_query)
		if result:
			if not just_attacked: attack()
			return
		
		#move
		animator.play("Basic/Walk")
		grid_movement.move(direction)
		await grid_movement.finished_step
		step_timer.start()

func attack():
	just_attacked = true
	can_move = false
	animator.play(Attack_animation)
	await animator.animation_finished
	attack_timer.start()
	await attack_timer.timeout
	can_move = true

func die():
	print("TODO: YOU ARE DEAD")

func on_hit():
	health.invincible = true
	invincibility_timer.start()

func end_invincibility():
	health.invincible = false
