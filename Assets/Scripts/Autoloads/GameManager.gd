extends Node


var _actualState:GameState = GameState.ACTIVE;
var _inputType:InputTypes = InputTypes.KEYBOARD;

enum GameState{
	ACTIVE,
	PAUSED
}
enum InputTypes{
	KEYBOARD,
	GAMEPAD
}

var _tutoDone:bool;
var _lastScene = 0;

signal inputChanged;

signal isPaused;
signal isAnPaused;

func _ready() -> void:
	isPaused.connect(_pause);
	isAnPaused.connect(_play);
	_tutoDone = Level.load_score().get("tutoDone");

func _pause():
	get_tree().paused = true;
	_actualState = GameState.PAUSED;

func _play():
	get_tree().paused = false;
	_actualState = GameState.ACTIVE;

func _input(event: InputEvent) -> void:
	inputChanged.emit(event);
	if event is InputEventKey or event is InputEventMouseButton or event is InputEventMouseMotion:
		_inputType = InputTypes.KEYBOARD;
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		_inputType = InputTypes.GAMEPAD;
	print(event,"----",_inputType);
