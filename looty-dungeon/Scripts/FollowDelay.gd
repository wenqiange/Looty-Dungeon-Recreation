class_name FollowDelay
extends enemyIA

var player:Player
var delay:Timer
@export var agent:NavigationAgent3D
@export var follow_radius:float=3

func _ready():
	super()
	player = get_tree().get_first_node_in_group("Player")
	
	for c in get_children():
		if c is Timer:
			delay = c
	
	if not delay: printerr("missing delay timer")
	if not agent: printerr("missing navigation agent") 
	
	delay.timeout.connect(_on_delay)

func _process(_delta: float) -> void:
	agent.target_position = player.position

func _on_delay():
	if enemy.position.distance_to(player.position) > follow_radius: return
	var next_pos = agent.get_next_path_position()
	var dir = next_pos - enemy.position
	var idir = global.vec_to_dir(Vector2(dir.x,dir.z).normalized())
	enemy.step(idir)
