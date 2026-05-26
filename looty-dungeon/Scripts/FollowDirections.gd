class_name followInput
extends enemyIA

var delay:Timer
@export var input_list:Array[global.direction]

var cur_input = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	
	for c in get_children():
		if c is Timer:
			delay = c
	
	if not delay: printerr("missing delay timer")
	delay.timeout.connect(_on_delay)

func _on_delay():
	var cur_dir = input_list[cur_input]
	cur_input = (cur_input + 1) % input_list.size()
	enemy.step(cur_dir)
