extends Node3D;

@export var _blackScreenAnimPlayer:AnimationPlayer;



func _ready():
	Level.Init();
	Level.MonsterKill.connect(UpdateScore);
	Level.GameFinished.connect(_game_finished);
	_blackScreenAnimPlayer.animation_finished.connect(BackToMenu);

func _game_finished():
	_blackScreenAnimPlayer.play("fade_in");


func BackToMenu(anim_name):
	if anim_name == "fade_in":
		get_tree().change_scene_to_file("res://Assets/Scenes/title_screen.tscn");

func UpdateScore():
	$CanvasLayer/Kill.text = "KILL "+str(Level._score);
	pass
