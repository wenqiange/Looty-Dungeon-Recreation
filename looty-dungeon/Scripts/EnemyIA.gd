class_name enemyIA
extends Node

@onready var enemy:Enemy

func _ready():
	enemy = get_parent() as Enemy
