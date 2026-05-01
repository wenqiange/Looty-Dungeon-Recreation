extends Node3D

@onready var grid_movement: GridMovement = $GridMovement
@onready var step_timer: Timer = $Step_timer
@onready var body: Node3D = $Body
@onready var health: Health = $Health
@onready var invincibility_timer: Timer = $"Invincibility timer"
@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var attack_timer: Timer = $"Attack timer"

@export var Attack_animation:String
@export var Action_animation:String

var can_move:bool = true

var just_attacked:bool = false

func _ready() -> void:	
	invincibility_timer.timeout.connect(end_invincibility)
	
	grid_movement.on_entity.connect(attack)
	
	health.got_hit.connect(on_hit)
	health.death.connect(die)
	
	animator.play("Basic/Idle")

func _process(delta: float) -> void:
	print(grid_movement.on_ground)
	if grid_movement.is_moving:
		animator.play("Basic/Walk")
	elif can_move:
		animator.play("Basic/Idle")

func _physics_process(_delta: float) -> void:
	if can_move:
		#check direction
		if grid_movement.is_moving or step_timer.time_left > 0: return
		var dir = Vector2(Input.get_axis("move_right","move_left"),Input.get_axis("move_down","move_up"))
		if dir.length() <= 0: 
			#animator.play("Basic/Idle")
			just_attacked = false
			return
		var direction = global.vec_to_dir(dir)
		
		#move
		grid_movement.move(direction)
		await  grid_movement.finished_step
		step_timer.start()

func attack():
	if just_attacked: return
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
