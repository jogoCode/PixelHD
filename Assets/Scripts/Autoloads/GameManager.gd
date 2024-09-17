extends Node


var _actualState:GameState = GameState.ACTIVE;
enum GameState{
	ACTIVE,
	PAUSED
}

var _tutoDone:bool;

var _lastScene = 0;

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
