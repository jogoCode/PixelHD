extends Node
class_name StateAnimation

# THIS STATE MACHINE MANAGE THE PLAYER
@onready var _character:Character = get_parent();
@export var _animationTree:AnimationTree;
@onready var _stateAnimation:AnimationNodeStateMachinePlayback = _animationTree["parameters/playback"];

var _actualState;
var _canAtk = true;

signal ChangeState(newState:String);
signal StateChanged;


var _weaponType:String = "Light";
var comboResetTimer =0.5;
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
	ComboTimer(delta);	

func ComboTimer(delta):
	if (comboResetTimer > 0):
		comboResetTimer -= 0.1*delta;
	if (comboResetTimer < 0.0001):
		combo = 1;
	comboResetTimer = clamp(comboResetTimer,0,0.15);
	
func SetState(newState):
	#_stateAnimation.travel(newState);
	_actualState = _stateAnimation.get_current_node();
	StateChanged.emit();

func GetState()->String:
	if _actualState == "AtkSpe":
		return _animationTree["parameters/AtkSpe/playback"].get_current_node();
	return _actualState;


func _get_configuration_warnings():
	var warnings = [];
	if(_animationTree == null):
		warnings.append("Please set AnimationTree to a non-empty value.")
	return warnings;
	

func IsAtk() -> void:
	StateChanged.emit();
	comboResetTimer += 0.5;
	_stateAnimation.travel("Atk");
	_animationTree["parameters/conditions/isIdle"] = false;
	_animationTree["parameters/conditions/isMoving"] = false;
	_animationTree["parameters/Atk/conditions/is"+_weaponType] = true;
	#System de combo v2
	_animationTree["parameters/Atk/"+_weaponType+"/conditions/isAtk0"+str(combo)] = true;
	combo+= 1;
	if combo >3:
		combo = 1;
	await get_tree().create_timer(0.001).timeout;
	_animationTree["parameters/Atk/conditions/is"+_weaponType] = false;
	_animationTree["parameters/Atk/"+_weaponType+"/conditions/isAtk01"] = false; 
	_animationTree["parameters/Atk/"+_weaponType+"/conditions/isAtk02"] = false;
	_animationTree["parameters/Atk/"+_weaponType+"/conditions/isAtk03"] = false;

func IsAction(newState:String,resetTime:float):
	StateChanged.emit();
	_stateAnimation.travel(newState);
	return;
	if(GetState()!= newState):
		_animationTree["parameters/conditions/is"+newState] = true; 
		await get_tree().create_timer(resetTime).timeout;
		_animationTree["parameters/conditions/is"+newState] = false; 

func Roll():
	pass
	# TODO: Ajouter la condition pour eviter le multitouch

func stateCheck():
	if(GetState() == "Atk" or 
	GetState() == "Roll" or
	GetState() == "EndRoll" or
	GetState() == "Hit" or
	GetState() == "BladeBounce" or 
	GetState() == "EndSharpen" or
	GetState() == "BigBlade"):
		return true;
	else:
		return false;

func IsHit():
	_animationTree["parameters/conditions/isHit"] = true;
	await get_tree().create_timer(0.2).timeout;
	_animationTree["parameters/conditions/isHit"] = false;

func IsDie():
	StateChanged.emit();
	#_animationTree["parameters/conditions/isAtk"] = false; 
	#_animationTree["parameters/conditions/isHit"] = false;
	_stateAnimation.travel("Die");
	_animationTree["parameters/conditions/isDie"] = true;

func _on_change_state(newState:String):
	SetState(newState);
