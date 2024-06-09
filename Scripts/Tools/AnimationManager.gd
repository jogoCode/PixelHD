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
		if vel.length() > 0.9:
			if(lastVel == Vector3(1,0,0) || lastVel == Vector3(-1,0,0) ):
				lastVel.z = 0;
			if(lastVel == Vector3(0,0,1) || lastVel == Vector3(0,0,-1)):
				lastVel.x = 0;
			print(lastVel);
			_animationTree["parameters/Idle/blend_position"] = Vector2(lastVel.x,-lastVel.z);
			_animationTree["parameters/Move/blend_position"] = Vector2(vel.x,-vel.z);
		if(vel.length()>0):
			_animationTree["parameters/Atk/blend_position"] = Vector2(vel.x,vel.z);
		else:
			_animationTree["parameters/Atk/blend_position"] = Vector2(sign(lastVel.x),sign(lastVel.z));
	else:
		vel = _character.velocity;
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
