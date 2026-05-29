class_name PlayerCoins
extends Node

signal coins_changed(total: int)
var coins: int = 0

func _ready() -> void:
	coins_changed.emit(coins)

func add_coin() -> void:
	coins += 1
	coins_changed.emit(coins)

func remove_coins(num:int) -> void:
	coins -= num
	coins_changed.emit(coins)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("cheat_coins"):
		add_coin()
