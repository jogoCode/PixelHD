extends Node
class_name StateAnimation

@onready var _character:Character = get_parent();
@export var _animationTree:AnimationTree;
@onready var _stateAnimation = _animationTree["parameters/playback"];

var _actualState;
var _canAtk = true;

signal ChangeState(newState:String);
signal StateChanged;


var combo:int = 1; 

func _ready():
	SetState("Idle");

func _process(delta):
	_actualState = _stateAnimation.get_current_node();
	if(_character.velocity.length()>0):
		_animationTree["parameters/conditions/isMoving"] = true;
		_animationTree["parameters/conditions/isIdle"] = false;
	elif(_character.velocity.length()==0):
		_animationTree["parameters/conditions/isIdle"] = true;
		_animationTree["parameters/conditions/isMoving"] = false;
	print(combo)

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
	

func IsAtk() -> void:
	if(combo==1):
		_animationTree["parameters/conditions/isAtk01"] = true;
	elif(combo==2):
		_animationTree["parameters/conditions/isAtk02"] = true;
	combo+= 1;
	if combo >2:
		combo = 1;
	await get_tree().create_timer(0.5).timeout;
	_animationTree["parameters/conditions/isAtk01"] = false; 
	_animationTree["parameters/conditions/isAtk02"] = false;
	

func IsAction(newState:String,resetTime:float):
	if(GetState()!= newState):
		_animationTree["parameters/conditions/is"+newState] = true; 
		await get_tree().create_timer(resetTime).timeout;
		_animationTree["parameters/conditions/is"+newState] = false; 

func Roll():
	pass
	# TODO: Ajouter la condition pour eviter le multitouch


func IsHit():
	pass
	#_animationTree["parameters/conditions/Hit"] = true;
	#await get_tree().create_timer(0.2).timeout;
	#_animationTree["parameters/conditions/Hit"] = false;


func _on_change_state(newState:String):
	print("AKA")
	SetState(newState);
