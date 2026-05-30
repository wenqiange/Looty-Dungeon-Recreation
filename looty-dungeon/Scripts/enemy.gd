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

#@export var death_sound: AudioStreamPlayer3D
#@export var move_sound: AudioStreamPlayer3D

signal finshed_action
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
	#if move_sound:
		#move_sound.play()
	animator.play(walk_animation)
	movement.move(direction)
	await movement.finished_action
	if can_move:
		finshed_action.emit()
		animator.play(idle_animation)

func idle():
	animator.play(idle_animation)

func attack(entity:Node3D):
	if entity is not Player: return
	can_move = false
	animator.play(attack_animation)
	await animator.animation_finished
	finshed_action.emit()
	can_move = true

func fall():
	can_move = false
	animator.play(fall_animation)
	await animator.animation_finished
	queue_free()

func on_die():
	can_move = false
	dead.emit()
	animator.play(die_animation)
	#death_sound.play()
	await animator.animation_finished
	#await death_sound.finished
	queue_free()
