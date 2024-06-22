extends Control
onready var healthbar = $Healthbar/Healthbar
onready var manabar = $Manabar/Manabar

var mana = PlayerStats.mana

func _ready():	
	healthbar.max_value = PlayerStats.maxHealth
	healthbar.value = PlayerStats.maxHealth	
	
	manabar.max_value = PlayerStats.maxMana
	manabar.value = PlayerStats.maxMana

	
func update_health():
	healthbar.max_value = PlayerStats.maxHealth
	healthbar.value = PlayerStats.health 
	
func update_mana():
	manabar.max_value = PlayerStats.maxMana
	manabar.value = PlayerStats.mana

func _on_Control_mouse_entered():
	modulate = Color(1,1,1,0.1)

func _on_Control_mouse_exited():
	modulate = Color(1,1,1,0.9)





