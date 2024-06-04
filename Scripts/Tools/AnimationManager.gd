extends Node

@export var _character:CharacterBody3D;
@export var _animationTree:AnimationTree;
@onready var _stateMachine = _animationTree["parameters/playback"];

func _ready():
	pass


func _process(delta):
	_animationTree["parameters/Idle/blend_position"] = Vector2(_character.velocity.x,_character.velocity.z);
	_animationTree["parameters/Move/blend_position"] = Vector2(_character.velocity.x,_character.velocity.z);
	if(_character.velocity.length()>1):
		_stateMachine.travel("Move");
	elif(_character.velocity.length()==0):
		_stateMachine.travel("Idle");	
