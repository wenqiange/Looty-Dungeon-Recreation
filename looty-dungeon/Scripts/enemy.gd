class_name Enemy
extends Node3D

@onready var movement: GridMovement = $GridMovement
@onready var delay: Timer = $Delay
@onready var animator: AnimationPlayer = $AnimationPlayer

var player: Node3D
var player_seen = false
var can_move = true

@export var see_radius:float

@export var idle_animation:String
@export var walk_animation:String
@export var attack_animation:String

func _ready() -> void:
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() <= 0:
		print_debug("missing player")
	else: player = players[0]
	
	movement.on_entity.connect(attack)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var dir = player.position - position
	player_seen = dir.length() <= see_radius

func _on_delay_timeout() -> void:
	if not can_move: return
	if not player_seen or movement.is_moving: 
		animator.play(idle_animation)
		return
	
	animator.play(walk_animation)
	
	var dir = player.position - position
	var idir = global.vec_to_dir(Vector2(dir.x,dir.z).normalized())
	movement.move(idir)

func attack(entity:Node3D):
	if entity is not Player: return
	can_move = false
	animator.play(attack_animation)
	await animator.animation_finished
	can_move = true
