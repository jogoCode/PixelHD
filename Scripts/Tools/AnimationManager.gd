extends Node

@export var _character:CharacterBody3D;
@export var _animationTree:AnimationTree;
@onready var _stateMachine = _animationTree["parameters/playback"];

func _ready():
	pass


func _process(delta):
	if(_character.velocity.length()>1):
		_stateMachine.travel("Move");
	elif(_character.velocity.length()==0):
		_stateMachine.travel("Idle");	
