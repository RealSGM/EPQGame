extends Node

func _process(delta):
	if Global.currentScene == "Game":
		PlayerData.timePlayed += delta

	if Global.currentMusic != null:
		match Global.currentMusic:
			"MainMenu":
				if $MainMenuMusic.playing == false:
					$MainMenuMusic.play()
				$LobbyMusic.stop()
				$GameMusic.stop()
				$BossMusic.stop()
			"Lobby":
				if $LobbyMusic.playing == false:
					$LobbyMusic.play()
				$MainMenuMusic.stop()
				$GameMusic.stop()
				$BossMusic.stop()
			"Game":
				if $GameMusic.playing == false:
					$GameMusic.play()
				$MainMenuMusic.stop()
				$LobbyMusic.stop()
				$BossMusic.stop()
			"Boss":
				$GameMusic.stop()
				if $BossMusic.playing == false:
					$BossMusic.play()



func _ready():	
	Global.music = self	
	$MainMenuMusic.volume_db = -25
	$LobbyMusic.volume_db = -25
	$GameMusic.volume_db = -30
	$RangedHit.volume_db = -20
	$MeleeHit.volume_db = -10
	$Footstep.volume_db = -30
	$BossMusic.volume_db = -30
