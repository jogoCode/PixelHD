extends CanvasLayer

@onready var _buttonPlay:Button = $VBoxContainer/ButtonPlay
@onready var _buttonQuit:Button = $VBoxContainer/ButtonQuit


func _ready():
	_buttonPlay.grab_focus();
	_buttonPlay.pressed.connect(play);
	_buttonQuit.pressed.connect(exit);


func _process(delta):
	pass

func play():
	print("jio")
	$ColorRect/AnimationPlayer.play("fade_in");


func exit():
	get_tree().quit()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_in":
		get_tree().change_scene_to_file("res://Assets/Scenes/room.tscn");
