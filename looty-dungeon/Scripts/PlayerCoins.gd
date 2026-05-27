class_name PlayerCoins
extends Node

signal coins_changed(total: int)
var coins: int = 0

func _ready() -> void:
	coins_changed.emit(coins)
	
	
func add_coin() -> void:
	coins += 1
	coins_changed.emit(coins)
