extends Control
class_name UIProgressBar

@export var _owner:Character;
@export var _progressBar:TextureProgressBar;
@export var _progressFactor:float = 5

func update_progressBar(progressBar,value,tween_type,time):
	var tween = get_tree().create_tween();
	tween.set_trans(tween_type);
	tween.tween_property(progressBar,"value",value,time);
