extends Node3D

@onready var camera: CameraFollow = $Camera3D

@export var initial_level:PackedScene

var cur_level:Level
var next_level:Level

var player:Player

func _ready() -> void:
	camera.lock = true
	player = get_tree().get_first_node_in_group("Player")
	
	cur_level = initial_level.instantiate()
	cur_level.position = Vector3(0,0,1) * 30
	add_child(cur_level)
	var player_pos = cur_level.player_spawn.position
	player.position = player_pos+cur_level.position
	
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(cur_level,"position",Vector3.ZERO,3)
	tween.parallel().tween_property(player,"position",player_pos,3)
	await tween.finished
	player.process_mode = Node.PROCESS_MODE_INHERIT
	camera.lock = false
	cur_level.start_falling()
	
