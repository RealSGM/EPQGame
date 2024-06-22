extends Node2D


onready var DurationTimer = $DurationState
onready var tickSpeed = $TimerDamageStates

signal DamageTaken
signal DurationStop

func _on_TimerDamageStates_timeout():
	if DurationTimer.time_left != 0:
		emit_signal("DamageTaken")



func RefreshTick(TickSpeed):
	tickSpeed.start(TickSpeed)

func StartTimers(Duration,TickSpeed):
	DurationTimer.start(Duration)
	tickSpeed.start(TickSpeed)


func _on_DurationState_timeout():
	tickSpeed.stop()
	emit_signal("DurationStop")
	
