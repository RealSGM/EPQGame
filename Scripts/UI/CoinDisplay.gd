extends Control


func _ready():
	$BG/CoinSFX.volume_db = -15

func update_coin_count():
	$BG/Amount.text = str(PlayerData.playerBalance)
	$BG/Coin.set_animation("coin_spin")
	$BG/Coin.play()


func _on_TextureButton_pressed():
	if $BG/CoinSFX.playing == false:
		$BG/CoinSFX.play()
