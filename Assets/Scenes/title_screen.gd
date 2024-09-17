extends screenManage

@onready var _buttonPlay:Button = $VBoxContainer/ButtonPlay
@onready var _buttonTutorial:Button = $VBoxContainer/ButtonTutorial
@onready var _buttonQuit:Button = $VBoxContainer/ButtonQuit

func _ready() -> void:
	super._ready();
	_buttonPlay.grab_focus();
	_buttonPlay.pressed.connect(play);
	_buttonTutorial.pressed.connect(tuto);
	_buttonQuit.pressed.connect(exit);
	if !GameManager._tutoDone:
		_buttonPlay.disabled = true;
