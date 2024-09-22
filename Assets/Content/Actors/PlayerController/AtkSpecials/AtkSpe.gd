extends Node
class_name AtkSpe;

@onready var _owner:PlayerCharacter = get_parent().get_parent();
var _isActive:bool;
var _atkSpeTimer:float = 0;
@export var _staminaCost:float;
signal set_atkSpe_time(value);
var _canRemoveStamina = false;

func _ready() -> void:
	set_atkSpe_time.connect(_set_atkSpe_time);

func action():
	#---stamina cost
	if _canRemoveStamina:
		_owner._staminaSys.remove_stamina.emit(_staminaCost);
		_canRemoveStamina = false;

func action_at_end():
	_owner.get_node("HealthSystem")._armor = 0;
	pass

func canRemoveStamina():
	_canRemoveStamina = true;

func _set_atkSpe_time(value:float)->void:
	_isActive = true;
	_atkSpeTimer = value;
