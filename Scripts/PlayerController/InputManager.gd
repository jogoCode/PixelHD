extends Node

@export var _playerCharacter:PlayerCharacter;

signal Interact;

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var inputDir = Input.get_vector("ui_left","ui_right","ui_up","ui_down");
	_playerCharacter.setDirection(inputDir.normalized());
	if(Input.is_action_pressed("ui_accept")):
		_playerCharacter.Atk();
	if(Input.is_action_just_pressed("Interact")):
		emit_signal("Interact");

func _input(event):
	pass;

func _get_configuration_warnings():
	var warnings = []

	if _playerCharacter == null:
		warnings.append("Please set PlayerCharacter to a non-empty value.")
	# Returning an empty array means "no warning".
	return warnings;
