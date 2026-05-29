class_name Enemy
extends Node3D

@onready var movement: GridMovement = $GridMovement
@onready var animator: AnimationPlayer = $AnimationPlayer
var player: Node3D
var player_seen = false
var can_move = true

@export var idle_animation:String
@export var walk_animation:String
@export var attack_animation:String
@export var die_animation:String
@export var fall_animation:String

signal dead

func _ready() -> void:
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() <= 0:
		print_debug("missing player")
	else: player = players[0]
	
	movement.on_entity.connect(attack)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not movement.on_ground and not movement.is_moving:
		fall()
		return

func step(direction: global.direction):
	if not can_move: return
	if movement.is_moving: return
	
	animator.play(walk_animation)
	movement.move(direction)
	await movement.finished_step
	if can_move:
		animator.play(idle_animation)

func idle():
	animator.play(idle_animation)

func attack(entity:Node3D):
	if entity is not Player: return
	can_move = false
	animator.play(attack_animation)
	await animator.animation_finished
	can_move = true

func fall():
	can_move = false
	animator.play(fall_animation)
	await animator.animation_finished
	queue_free()

func on_die():
	can_move = false
	animator.play(die_animation)
	await animator.animation_finished
	dead.emit()
	queue_free()
