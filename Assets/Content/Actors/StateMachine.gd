extends StateAnimation
#class_name StateAnimation

#@onready var _character:Character = get_parent();
#@export var _animationTree:AnimationTree;
#@onready var _stateAnimation = _animationTree["parameters/playback"];
#
#var _actualState;
#var _canAtk = true;
#
#signal ChangeState(newState:String);
#signal StateChanged;


# ONLY FOR ENEMY

func _ready():
	SetState("Idle");

func _process(delta):
	_actualState = _stateAnimation.get_current_node();
	if(_character.velocity.length()>0):
		_animationTree["parameters/conditions/IsMoving"] = true;
		_animationTree["parameters/conditions/IsIdle"] = false;
	elif(_character.velocity.length()==0):
		_animationTree["parameters/conditions/IsIdle"] = true;
		_animationTree["parameters/conditions/IsMoving"] = false;

func SetState(newState):
	#_stateAnimation.travel(newState);
	_actualState = _stateAnimation.get_current_node();

func GetState()->String:
	return _actualState;


func _get_configuration_warnings():
	var warnings = [];
	if(_animationTree == null):
		warnings.append("Please set AnimationTree to a non-empty value.")
	return warnings;
	


func _on_weapon_atk_finished():
	_canAtk = true;

func IsAtk() -> void:
	if(_canAtk):
		#_canAtk = false;
		_animationTree["parameters/conditions/Atk"] = true; 
		await get_tree().create_timer(0.1).timeout;
		_animationTree["parameters/conditions/Atk"] = false; 

func IsDie():
	_animationTree["parameters/conditions/Atk"] = false; 
	_animationTree["parameters/conditions/isHit"] = false;
	_animationTree["parameters/conditions/Die"] = true;

func MoveBackward():
	pass

func _on_change_state(newState:String):
	print("AKA")
	SetState(newState);
