extends Node

@export var _playerCharacter:PlayerCharacter;

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var inputDir = Input.get_vector("ui_left","ui_right","ui_down","ui_up");
	_playerCharacter.setDirection(inputDir.normalized());
	if(Input.is_action_just_pressed("ui_accept")):
		_playerCharacter.Atk();

func _input(event):
	pass;

func _get_configuration_warnings():
	var warnings = []

	if _playerCharacter == null:
		warnings.append("Please set PlayerCharacter to a non-empty value.")
	
	# Returning an empty array means "no warning".
	return warnings;
