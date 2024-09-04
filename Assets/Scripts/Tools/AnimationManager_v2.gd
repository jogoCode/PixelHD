extends Node
class_name AnimationManager

@export var _character:Character;
@export var _animationTree:AnimationTree;
@onready var _stateAnimation = _animationTree["parameters/playback"];

var _animSpeed:float = 1;

func _ready():
	if(_character == null):
		printerr("_character variable is null");
	if(_stateAnimation == null):
		printerr("_stateAnimation variable is null");


func _set_anim_speed(value):
	_animSpeed = value;

