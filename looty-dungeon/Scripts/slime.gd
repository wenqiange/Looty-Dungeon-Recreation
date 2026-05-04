extends Node3D

@onready var movement: GridMovement = $GridMovement
@onready var delay: Timer = $Delay
@onready var animator: AnimationPlayer = $AnimationPlayer

var player: Node3D
var player_seen = false

@export var see_radius:float

func _ready() -> void:
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() <= 0:
		print_debug("missing player")
	else: player = players[0]
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var dir = player.position - position
	player_seen = dir.length() <= see_radius

func _on_delay_timeout() -> void:
	if not player_seen: return
	if movement.is_moving: return
	
	var dir = player.position - position
	var idir = global.vec_to_dir(Vector2(dir.x,dir.z).normalized())
	movement.move(idir)
