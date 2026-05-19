class_name Health
extends Node

@export var max_health:int
@export var invincible:bool
var cur_health

signal health_updated(val:int)
signal got_hit()
signal death()

func _ready() -> void:
	cur_health = max_health
	for c in get_parent().get_children():
		if c is HitBox:
			var hb = c as HitBox
			hb.area_entered.connect(func(area:Area3D):if area is DamageArea: on_hit())

func on_heal(val:int):
	cur_health += val
	if cur_health > max_health: cur_health = max_health
	health_updated.emit(cur_health)
	if cur_health <= 0:
		cur_health = 0
		death.emit()

func on_hit():
	if invincible: return
	cur_health -= 1
	health_updated.emit(cur_health)
	if cur_health <= 0:
		cur_health = 0
		death.emit()
	else: 
		got_hit.emit()
