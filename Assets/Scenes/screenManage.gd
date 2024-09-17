extends CanvasLayer
class_name screenManage

var _action:ActionMenu;

enum ActionMenu{
	PLAY,
	EXIT,
	MENU,
	TUTO
}


func _ready():
	$ColorRect/AnimationPlayer.animation_finished.connect(_on_animation_player_animation_finished);


func play():
	_action = ActionMenu.PLAY;
	print(_action)
	startTransition();

func tuto():
	_action = ActionMenu.TUTO;
	startTransition();

func mainMenu():
	_action = ActionMenu.MENU;
	startTransition();

func exit():
	_action = ActionMenu.EXIT;
	startTransition();

func startTransition():
	$ColorRect/AnimationPlayer.play("fade_in");

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_in":
		match _action:	
			ActionMenu.PLAY:
				if GameManager._lastScene == 0:
					get_tree().change_scene_to_file("res://Assets/Scenes/room.tscn");
				if GameManager._lastScene == 1:
					get_tree().change_scene_to_file("res://Assets/Scenes/tuto.tscn");
			ActionMenu.EXIT:
				get_tree().quit();
			ActionMenu.MENU:
				get_tree().change_scene_to_file("res://Assets/Scenes/title_screen.tscn");
			ActionMenu.TUTO:
				get_tree().change_scene_to_file("res://Assets/Scenes/tuto.tscn");
