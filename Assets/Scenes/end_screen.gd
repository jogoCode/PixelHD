extends screenManage

@onready var _buttonRestart:Button = $VBoxContainer/ButtonRestart;
@onready var _buttonMainMenu:Button = $VBoxContainer/ButtonMainMenu;

func _ready() -> void:
	super._ready();
	_buttonRestart.grab_focus();
	_buttonRestart.pressed.connect(play);
	_buttonMainMenu.pressed.connect(mainMenu);
	display_score();


func display_score():
	$Score/ActualScore.text = "Score  "+str(Level._score);
	$Score/BestScore.text = "Best score "+str(Level._hightScore);
