class_name Level
extends Node3D

@onready var falling_ground: FallingGround = null

@export var player_spawn:Node3D
var num_enemies

signal no_enemies
signal on_level_finished

func _ready() -> void:
	num_enemies = 0
	for c in get_children():
		if c.is_in_group("enemies"):
			c.process_mode = Node.PROCESS_MODE_DISABLED
			num_enemies += 1
			(c as Enemy).dead.connect(enemy_dead)
		if c is FallingGround:
			falling_ground = c
	if num_enemies == 0:
		no_enemies.emit()

func start_falling():
	if falling_ground:
		falling_ground.start()
	for c in get_children():
		if c.is_in_group("enemies"):
			c.process_mode = Node.PROCESS_MODE_INHERIT

func enemy_dead():
	num_enemies -= 1
	if num_enemies <= 0:
		no_enemies.emit()

func finished():
	on_level_finished.emit()
