class_name Level
extends Node3D

@onready var falling_ground: Node3D = $Falling_Ground

@export var player_spawn:Node3D

func _ready() -> void:
	for c in get_children():
		if c.is_in_group("enemies"):
			c.process_mode = Node.PROCESS_MODE_DISABLED

func start_falling():
	falling_ground.start()
	for c in get_children():
		if c.is_in_group("enemies"):
			c.process_mode = Node.PROCESS_MODE_INHERIT
