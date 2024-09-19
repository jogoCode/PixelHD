extends Node
class_name AtkSpe;

@onready var _owner:PlayerCharacter = get_parent().get_parent();
var _isActive:bool;
var _atkSpeTimer:float = 0;
signal set_atkSpe_time(value);

func _ready() -> void:
	set_atkSpe_time.connect(_set_atkSpe_time);

func action():
	pass;

func action_at_end():
	pass;

func _set_atkSpe_time(value:float)->void:
	_isActive = true;
	_atkSpeTimer = value;
