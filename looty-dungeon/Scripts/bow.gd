extends Node

var player:Player
var animator:AnimationPlayer

@export var max_dist:int
@export var min_dist:int
@export var min_hold_time:float
const Arrow_path = "uid://o68de7frxg5w"

@onready var hold_timer: Timer = $HoldTimer
@onready var delay_timer: Timer = $DelayTimer

var falling = false

func _ready() -> void:
	player = get_parent() as Player
	animator = player.animator

func _process(_delta: float) -> void:
	if not animator: animator = player.animator
	
	if falling: return
	if not player.grid_movement.on_ground:
		hold_timer.stop()
		animator.stop()
		player.can_move = true
		falling = true  
		return
	
	if not delay_timer.is_stopped(): return
	
	if Input.is_action_just_pressed("Action"):
		hold_timer.start()
		animator.play("Arquero/Hold")
		player.can_move = false
	elif Input.is_action_just_released("Action"):
		if hold_timer.is_stopped(): return
		var strength = 1 - hold_timer.time_left / hold_timer.wait_time  
		if hold_timer.wait_time-hold_timer.time_left < min_hold_time:
			hold_timer.stop()
			player.can_move = true
			return
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
	arrow.position = player.position + Vector3.BACK.rotated(Vector3.UP, player.get_look_rot().y)*0.5
	player.add_sibling(arrow)
	delay_timer.start()
	$ArrowSound.play()

func _on_hold_timer_timeout() -> void:
	animator.play("Arquero/Action")
	shoot(1.)
	await  animator.animation_finished
	player.can_move = true
