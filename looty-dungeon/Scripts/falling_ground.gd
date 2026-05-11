extends Node3D


@onready var fall_timer: Timer = $fall_timer

@export var initialZ:int = 0
@export var falling_time:float
@export var animation_time:float

var cur_z:int

func _ready() -> void:
	cur_z = initialZ
	fall_timer.wait_time = falling_time
	fall_timer.start()

func _on_fall_timer_timeout() -> void:
	for c in get_children():
		if c is not Node3D: continue
		var tile = c as Node3D
		if round(tile.position.z) <= cur_z:
			#TODO: mejorar animacion
			var tween = get_tree().create_tween()
			tween.tween_property(tile,"position",Vector3.DOWN*10,animation_time).as_relative().set_delay(randf()*0.2)
			tween.chain().tween_callback(tile.queue_free)
	
	cur_z += 1
