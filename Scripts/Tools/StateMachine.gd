extends Node
class_name  StateAnimation

@onready var _character:Character = get_parent();
@export var _animationTree:AnimationTree;
@onready var _stateAnimation = _animationTree["parameters/playback"];

var _actualState;
var _canAtk = true;

signal StateChanged;

func _ready():
	SetState("Idle");

func _process(delta):
	if(_character.velocity.length()>0):
		SetState("Move");
	elif(_character.velocity.length()==0):
		SetState("Idle");
	if(Input.is_action_just_pressed("ui_accept") and _canAtk):
		_canAtk = false;
		SetState("Atk");
	print(_canAtk);

func SetState(newState):
	_stateAnimation.travel(newState);
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
