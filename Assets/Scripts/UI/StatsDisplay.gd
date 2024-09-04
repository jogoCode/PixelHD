extends Control
class_name StatsDisplay


@export var _owner:Node3D;
var _statsWeapon:R_Weapon;
@export var _nameTxt:Label;
@export var _img:TextureRect;
@export var _dmgTxt:Label;
@export var _descTxt:Label;


		
func _process(delta):
	DisplayState();

func DisplayState():
	if _owner is ObjPickup:
		_statsWeapon = _owner._weapon;
	else:
		_statsWeapon = Level._PLAYER._weapon._weaponActualStats;
	_nameTxt.text = _statsWeapon._name;
	_img.texture = _statsWeapon._img;
	_dmgTxt.text = str(_statsWeapon._dmg);
	_descTxt.text = _statsWeapon._desc;
