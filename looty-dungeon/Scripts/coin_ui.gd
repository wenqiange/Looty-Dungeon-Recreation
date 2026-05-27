extends Label

@onready var player_coins: PlayerCoins = $"../../PlayerCoins"

func _ready() -> void:
	if player_coins:
		
		player_coins.coins_changed.connect(_on_coins_changed)
		_on_coins_changed(player_coins.coins)

func _on_coins_changed(total: int) -> void:
	text = str(total)
