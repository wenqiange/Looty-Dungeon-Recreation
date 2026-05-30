extends FollowDelay

@export var step_delay:float
@export var idle_time:float

@export var min_steps:int
@export var max_steps:int

var num_steps:int = 0

func _ready():
	super()
	delay.start(idle_time)

func _on_delay():
	if not following:
		delay.start(idle_time)
		return
	if num_steps <= 0: num_steps = randi_range(min_steps,max_steps)
	num_steps -= 1
	var next_pos = agent.get_next_path_position()
	var dir = next_pos - enemy.position
	var idir = global.vec_to_dir(Vector2(dir.x,dir.z).normalized())
	enemy.step(idir)
	await enemy.finshed_action
	if num_steps > 0:
		delay.start(step_delay)
	else:
		delay.start(idle_time)
