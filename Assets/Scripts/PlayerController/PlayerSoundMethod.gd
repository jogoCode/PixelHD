extends Node


func _play_foot_step():
	SoundFx.play("FootSteps",0);
	
func _play_roll():
	SoundFx.play("Roll",0);


func _play(sound:String):
	SoundFx.play(sound,0);
