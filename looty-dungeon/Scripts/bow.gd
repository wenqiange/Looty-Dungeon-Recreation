extends Node

var player:Player
var animator:AnimationPlayer

@export var max_dist:int
@export var min_dist:int
const Arrow_path = "uid://o68de7frxg5w"

@onready var hold_timer: Timer = $HoldTimer

func _ready() -> void:
	player = get_parent() as Player
	animator = player.animator

func _process(delta: float) -> void:
	if not animator: animator = player.animator
	
	if Input.is_action_just_pressed("Action"):
		hold_timer.start()
		animator.play("Arquero/Hold")
		player.can_move = false
	elif Input.is_action_just_released("Action"):
		if hold_timer.is_stopped(): return
		var strength = 1 - hold_timer.time_left / hold_timer.wait_time
		hold_timer.stop()
		shoot(strength)
		animator.play("Arquero/Action")
		await  animator.animation_finished
		player.can_move = true

func shoot(strength:float):
	var dist = round(strength*(max_dist-min_dist)) + min_dist
	var arrow = preload(Arrow_path).instantiate() as Arrow
	arrow.distance = dist
	arrow.rotation = player.get_look_rot()
	arrow.position = player.position
	player.add_sibling(arrow)

func _on_hold_timer_timeout() -> void:
	animator.play("Arquero/Action")
	shoot(1.)
	await  animator.animation_finished
	player.can_move = true
