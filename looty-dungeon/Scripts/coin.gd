class_name Coin
extends Area3D

const ROTATE = 1.0

func _process(_delta: float) -> void:
	rotate_y(deg_to_rad(ROTATE))
	
func _on_area_entered(area: Area3D) -> void:
	var owner_node: Node = area.get_parent()
	
	if owner_node is Player:
		var player_coins: PlayerCoins = owner_node.get_node_or_null("PlayerCoins")
		if player_coins:
			player_coins.add_coin()
		
		#monitoring = false 
		$CollisionShape3D.disabled = true
		hide() 
		if has_node("CoinSound"):
			$CoinSound.play()
			$CoinSound.finished.connect(queue_free)
		else:
			queue_free()
