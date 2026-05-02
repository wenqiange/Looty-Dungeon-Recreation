class_name Arrow
extends Node3D

@export var distance:float
@export var distance_offset:float
@export var velocity:float


var cur_distance:float = 0

var falling = false
var fall_velocity = 0
var gravity = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cur_distance = distance_offset

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var dir = global_transform.basis.z
	cur_distance += velocity*delta
	fall_velocity += gravity*delta
	position += (dir*velocity + Vector3.DOWN*fall_velocity)*delta

func _process(_delta: float) -> void:
	if cur_distance >= distance-1: 
		fall()

func fall():
	if falling: return
	falling = true
	#tiempo de caida en una casilla de distancia
	gravity = velocity*velocity
	await get_tree().create_timer(1.0/velocity).timeout
	queue_free()


func _on_damage_box_area_entered(area: Area3D) -> void:
	queue_free()


func _on_damage_box_body_entered(_body: Node3D) -> void:
	queue_free()
