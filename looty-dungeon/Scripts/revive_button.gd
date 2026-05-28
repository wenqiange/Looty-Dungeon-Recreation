extends Button

@export var player:Player

func _ready() -> void:
	player.player_coins.coins_changed.connect(update_button)

func update_button(total:int):
	disabled = total < 5
