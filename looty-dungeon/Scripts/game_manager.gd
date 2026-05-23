extends Node3D

@onready var camera: CameraFollow = $Camera3D

@export var initial_level:PackedScene

var cur_level:Level

var player:Player

var changing:bool = false

func _ready() -> void: 
	$fade_transition/AnimationPlayer.play("fade_out")
	
	player = get_tree().get_first_node_in_group("Player")
	player.process_mode = Node.PROCESS_MODE_DISABLED
	
	changing = true
	await enter_level(initial_level)
	changing = false
	

func enter_level(level:PackedScene):
	camera.lock = true
	
	cur_level = level.instantiate()
	cur_level.position = Vector3(0,0,1) * 30
	add_child(cur_level)
	var player_pos = cur_level.player_spawn.position
	player.position = player_pos+cur_level.position
	camera.lock_position = player_pos
	
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(cur_level,"position",Vector3.ZERO,3)
	tween.parallel().tween_property(player,"position",player_pos,3)
	await tween.finished
	player.process_mode = Node.PROCESS_MODE_INHERIT
	camera.lock = false
	cur_level.start_falling()

func exit_level():
	camera.lock_position = player.position
	camera.lock = true
	
	player.process_mode = Node.PROCESS_MODE_DISABLED
	
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(cur_level,"position",Vector3.FORWARD*30,3)
	tween.parallel().tween_property(player,"position",Vector3.FORWARD*30,3)
	await tween.finished
	cur_level.queue_free()
	cur_level = null

func change_level(level:PackedScene):
	if changing: return
	changing = true
	if cur_level != null:
		await exit_level()
	await enter_level(level)
	changing = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug"):
		change_level(initial_level)
