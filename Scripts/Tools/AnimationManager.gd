extends Node

@export var _character:Character;
@export var _animationTree:AnimationTree;
@onready var _stateAnimation = _animationTree["parameters/playback"];

func _ready():
	pass

func _physics_process(delta):
	var stateAnimation = _stateAnimation;
	var lastVel = _character.getLastDir();
	var vel:Vector3;
	if(_character is PlayerCharacter):
		vel= _character._playerOrientation;
		_animationTree["parameters/Idle/blend_position"] = Vector2(sign(lastVel.x),sign(lastVel.z));
		_animationTree["parameters/Move/blend_position"] = Vector2(vel.x,-vel.z);
		_animationTree["parameters/Atk/blend_position"] = Vector2(sign(lastVel.x),sign(lastVel.z));
	else:
		vel = _character.velocity;
		#_animationTree["parameters/Idle/blend_position"] = Vector2(sign(lastVel.x),sign(lastVel.z));
		_animationTree["parameters/Move/Move/blend_position"] = Vector2(vel.x,-vel.z);
		_animationTree["parameters/Atk/Atk/blend_position"] = Vector2(sign(lastVel.x),sign(lastVel.z));

func _get_configuration_warnings():
	var warnings = []

	if _character == null:
		warnings.append("Please set PlayerCharacter to a non-empty value.")
	
	if _animationTree == null:
		warnings.append("Please set AnimationTree to a non-empty value.")
	# Returning an empty array means "no warning".
	return warnings;
