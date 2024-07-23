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
			_animationTree["parameters/Idle/blend_position"] = lastVel.x;
			_animationTree["parameters/Walk/blend_position"] = vel.x;
			_animationTree["parameters/Roll/blend_position"] = vel.x;
			_animationTree["parameters/EndRoll/blend_position"] = vel.x;
			_animationTree["parameters/Atk01/Atk_01/blend_position"] = vel.x;
			_animationTree["parameters/Atk02/Atk_02/blend_position"] = vel.x;
	else: #EnemyCharacter
		vel = _character.velocity;
		_animationTree["parameters/Move/Move/blend_position"] = Vector2(vel.x,-vel.z);
		if(_character._stateMachine.GetState()!= "Atk"):
			_animationTree["parameters/Atk/blend_position"] = Vector2(vel.x,vel.z);

	#_animationTree["parameters/Hit/blend_position"] = Vector2(sign(lastVel.x),sign(lastVel.z));

func _get_configuration_warnings():
	var warnings = []

	if _character == null:
		warnings.append("Please set PlayerCharacter to a non-empty value.")
	
	if _animationTree == null:
		warnings.append("Please set AnimationTree to a non-empty value.")
	# Returning an empty array means "no warning".
	return warnings;
