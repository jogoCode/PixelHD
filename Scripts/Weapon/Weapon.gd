extends Node3D

@export var _owner:Character;

var direction;
var inputVector;

@export var _weaponActualStats:R_Weapon;
@onready var _sprite = $WeaponSprite; 
var _dmg:int;

func _ready():
	hide();
	SetWeapon(_weaponActualStats);


func _process(delta):
	if(_owner._stateMachine.GetState() == "Atk"):
		show();
	else:
		hide();
	WeaponOrientation();	
func WeaponOrientation()->void:
	match _owner.GetPlayerOrientation():
		Vector3(1,0,0): #Right
			rotation_degrees = Vector3(0,0,0);
		Vector3(-1,0,0): #Left
			rotation_degrees = Vector3(0,-180,0);
		Vector3(0,0,-1): #Down
			rotation_degrees = Vector3(0,-90,0);
		Vector3(0,0,1): #Up
			rotation_degrees = Vector3(0,90,0);
		#----------------DIAG--------------------------
		Vector3(1,0,1): #DiagUpRight
			rotation_degrees = Vector3(0,90,0);
		Vector3(-1,0,1): #DiagDownLeft
			rotation_degrees = Vector3(0,90,0);
		Vector3(-1,0,-1): #DiagUpLeft
			rotation_degrees = Vector3(0,-90,0);
		Vector3(1,0,-1): #DiagDownRight
			rotation_degrees = Vector3(0,-90,0);	

func SetWeapon(newWeapon:R_Weapon):
	_weaponActualStats = newWeapon;
	_sprite.texture = _weaponActualStats._img;
	_dmg = _weaponActualStats._dmg;
