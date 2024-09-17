extends Control
class_name StatsDisplay

enum Type{
	WEAPON,
	OBJECT
}

@export var _actualType:Type = Type.WEAPON
@export var _owner:Node;
var _statsWeapon:R_Weapon;
var _statsObject:R_Object;
@export var _nameTxt:Label;
@export var _img:TextureRect;
@export var _dmgTxt:Label;
@export var _atkSpdTxt:Label;
@export var _descTxt:Label;
var _isInit:bool;

func _process(delta):
	DisplayState();

func DisplayState():
	match _actualType:
		Type.WEAPON:
			if _owner == null:
				_owner = owner
			if _owner is ObjPickup or _owner is StoreChoice:
				_statsWeapon = _owner._weapon;
			elif Level._PLAYER != null:
				_statsWeapon = Level._PLAYER._weapon._weaponActualStats;
			if _statsWeapon != null:
				_nameTxt.text = _statsWeapon._name;
				_img.texture = _statsWeapon._img;
				_dmgTxt.text = str(_statsWeapon._dmg);
				atkDisplayer(_statsWeapon._atkSpeed);
				_atkSpdTxt.show();
				_dmgTxt.show();
				_descTxt.hide();
		Type.OBJECT:
			if _owner == null:
				_owner = owner
			if _owner is ObjPickup or _owner is StoreChoice:
				_statsObject = _owner._object;
			if !_isInit:
				_isInit = true;
				_statsObject.init();
			_nameTxt.text = _statsObject._name;
			_img.texture = _statsObject._img;
			_dmgTxt.text = "";
			_descTxt.text = _statsObject._desc;
			_atkSpdTxt.hide();
			_dmgTxt.hide();
			_descTxt.show();


func atkDisplayer(atkSpd):
	if atkSpd >=1.5:
		_atkSpdTxt.text = "A";
		_atkSpdTxt.modulate = Color.html("#c2d672");
	if atkSpd >=1 and atkSpd < 1.5:
		_atkSpdTxt.text = "B";
		_atkSpdTxt.modulate = Color.html("f5c75d");
	if atkSpd >0 and atkSpd <1:
		_atkSpdTxt.text = "C";	
		_atkSpdTxt.modulate = Color.html("#c36050");
