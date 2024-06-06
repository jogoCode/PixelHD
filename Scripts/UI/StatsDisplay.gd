extends Control
class_name StatsDisplay

@onready var _statsWeapon:R_Weapon = get_parent().get_parent()._weapon;
@export var _nameTxt:Label;
@export var _img:TextureRect;
@export var _dmgTxt:Label;
@export var _descTxt:Label;


func _ready():
	pass # Replace with function body.

func _process(delta):
	DisplayState();

func DisplayState():
	_nameTxt.text = _statsWeapon._name;
	_img.texture = _statsWeapon._img;
	_dmgTxt.text = str(_statsWeapon._dmg);
	_descTxt.text = _statsWeapon._desc;
