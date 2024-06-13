extends Node3D

@export var _owner:Character;

var direction;
var inputVector;

@export var _weaponActualStats:R_Weapon;
@export var _sprite:Sprite3D; 
@export var _hitBox:CollisionShape3D;

# ajouter la création du pickup 

var _dmg:int;
var _cooldown:float;

signal ChangeWeapon(newWeapon:R_Weapon,dropPos:Vector3);
signal AtkFinished();

func _ready():
	hide();
	SetWeapon(_weaponActualStats);


func _process(delta):
	if(_owner._stateMachine.GetState() == "Atk"):
			show();
			_owner._stateMachine._animationTree["parameters/conditions/Atk"] = false; 
			$AnimationPlayer.play("Atk");
			_hitBox.disabled = false;
	else:
		hide();
		if(_hitBox.disabled == false):
			_hitBox.disabled = true;
			await  get_tree().create_timer(_cooldown).timeout;
		emit_signal("AtkFinished");
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
	_sprite.texture = newWeapon._img;
	_dmg =  newWeapon._dmg;
	_cooldown = newWeapon._atkSpeed;


func _on_change_weapon(newWeapon:R_Weapon,dropPos:Vector3):
	var pickup = preload("res://Prefabs/objPickup.tscn");
	var pickupInstance:ObjPickup = pickup.instantiate();
	pickupInstance._weapon = _weaponActualStats;
	SetWeapon(newWeapon);
	Level.CreateObject(pickupInstance,dropPos,Vector3(0,1,0));


func _on_area_3d_area_entered(area):
	if area.get_parent() != self.get_parent():
		for node in area.get_parent().get_children():
			if node.has_signal("TakeDamage"):
				node.emit_signal("TakeDamage",_weaponActualStats._dmg,_owner);
