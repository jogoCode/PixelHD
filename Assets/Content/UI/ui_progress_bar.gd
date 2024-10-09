extends Control
class_name UIProgressBar

@export var _owner:Character;
@export var _progressBar:TextureProgressBar;
@export var _progressFactor:float = 5
@export var _tweenType:Tween.TransitionType = Tween.TransitionType.TRANS_ELASTIC;

signal set_max_value();


func update_progressBar(progressBar,value,tween_type,time):
	tween_type = _tweenType;
	var tween = get_tree().create_tween();
	tween.set_trans(tween_type);
	tween.tween_property(progressBar,"value",value,time);
