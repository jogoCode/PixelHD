extends Node3D

@export var _owner:Character;

var direction;
var inputVector;

@export var _weaponActualStats:R_Weapon;
@onready var _sprite = $WeaponSprite; 
@export var _hitBox:CollisionShape3D;

# ajouter la création du pickup 

var _dmg:int;

signal ChangeWeapon(newWeapon:R_Weapon,dropPos:Vector3);

func _ready():
	hide();
	SetWeapon(_weaponActualStats);


func _process(delta):
	if(_owner._stateMachine.GetState() == "Atk"):
		show();
		_hitBox.disabled = false;
	else:
		hide();
		_hitBox.disabled = true;
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
	_sprite.texture =  newWeapon._img;
	_dmg =  newWeapon._dmg;


func _on_change_weapon(newWeapon:R_Weapon,dropPos:Vector3):
	var pickup = preload("res://Prefabs/objPickup.tscn");
	var pickupInstance:ObjPickup = pickup.instantiate();
	pickupInstance._weapon = _weaponActualStats;
	SetWeapon(newWeapon);
	Level.CreateObject(pickupInstance,dropPos,Vector3.ZERO);
