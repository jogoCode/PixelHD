extends Node3D;

@export var _blackScreenAnimPlayer:AnimationPlayer;
@export var _actualType:RoomTypes = RoomTypes.NORMAL;

	
enum RoomTypes{
	NORMAL,
	TUTO
}

func _ready():
	Level.Init();
	Level.MonsterKill.connect(UpdateScore);
	Level.addSoul.connect(UpdateSoul);
	Level.GameFinished.connect(_game_finished);
	_blackScreenAnimPlayer.animation_finished.connect(GoToEndScreen);

func _process(delta: float) -> void:
	UpdateFps();

func _game_finished():
	Level.save_score();
	_blackScreenAnimPlayer.play("fade_in");

func _tuto_finished():
	_blackScreenAnimPlayer.animation_finished.connect(GoToNormalRoom);
	_blackScreenAnimPlayer.play("fade_in_tuto");

func GoToEndScreen(anim_name):
	if anim_name == "fade_in":
		get_tree().change_scene_to_file("res://Assets/Scenes/end_screen.tscn");

func GoToNormalRoom(anim_name):
	if anim_name == "fade_in_tuto":
		get_tree().change_scene_to_file("res://Assets/Scenes/room.tscn");

func UpdateScore():
	$Hud/Kill.text = "KILL "+str(Level._score);

func UpdateSoul():
	$Hud/Soul.text = str(Level._soul);

func UpdateFps():	
	return;
	$Hud/Fps.text = "fps "+str(Engine.get_frames_per_second());
