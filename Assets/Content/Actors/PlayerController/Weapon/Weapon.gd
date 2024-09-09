extends Node3D
class_name Weapon;

@export var _owner:Character;

var direction;
var inputVector;

@export var _weaponActualStats:R_Weapon;
@export var _sprite:Sprite3D; 
@export var _hitBox:CollisionShape3D;
@export var _slashSfx:AnimatedSprite3D;

# ajouter la création du pickup 

var _dmg:int;
var _cooldown:float;
var _hitBoxTime:float;
var _isHit:bool;

signal ChangeWeapon(newWeapon:R_Weapon,dropPos:Vector3);
signal AtkFinished();

func _ready():
	#hide();
	rotation_degrees = Vector3(-45,0,-11.6);
	await  get_tree().create_timer(0.5).timeout;
	SetWeapon(_weaponActualStats);


func _physics_process(delta):
	if(_owner._stateMachine.GetState() == "Atk01" or 
	   _owner._stateMachine.GetState() == "Atk02" or 
	   _owner._stateMachine.GetState() == "Atk03"):
			#await  get_tree().create_timer(_cooldown).timeout;
			show();
			_slashSfx.modulate = _weaponActualStats._fxColor;
			_owner._stateMachine._animationTree["parameters/conditions/isAtk"] = false; 
			if _isHit != false:
				_hitBox.disabled = true;
	else:
		hide();
		#if(_hitBox.disabled == false):
		_hitBox.disabled = true;
		_isHit = false;
			#await  get_tree().create_timer(_cooldown).timeout;
		emit_signal("AtkFinished");
	HitBoxOrientation();

func  HitBoxOrientation():
	var area3d = _hitBox.get_parent();
	match _owner.GetPlayerOrientation():
		Vector3(1,0,0): #Right
			area3d.rotation_degrees = Vector3(45,5,5);
		Vector3(-1,0,0): #Left
			area3d.rotation_degrees = Vector3(-45,180,-11);

func WeaponOrientation()->void: #OBSOLETE
	pass
	#match _owner.GetPlayerOrientation():
		#Vector3(1,0,0): #Right
			#rotation_degrees = Vector3(0,0,0);
		#Vector3(-1,0,0): #Left
			#rotation_degrees = Vector3(0,-180,0);
		#Vector3(0,0,-1): #Down
			#rotation_degrees = Vector3(0,-90,0);
		#Vector3(0,0,1): #Up
			#rotation_degrees = Vector3(0,90,0);
		##----------------DIAG--------------------------
		#Vector3(1,0,1): #DiagUpRight
			#rotation_degrees = Vector3(0,90,0);
		#Vector3(-1,0,1): #DiagDownLeft
			#rotation_degrees = Vector3(0,90,0);
		#Vector3(-1,0,-1): #DiagUpLeft
			#rotation_degrees = Vector3(0,-90,0);
		#Vector3(1,0,-1): #DiagDownRight
			#rotation_degrees = Vector3(0,-90,0);	


func GetWeaponData():
	return _weaponActualStats;

func ActiveHitBox(timeToDisable):
	_hitBox.disabled = false;
	await get_tree().create_timer(timeToDisable).timeout;
	_hitBox.disabled = true;

func SetWeapon(newWeapon:R_Weapon):
	_weaponActualStats = newWeapon;
	_sprite.texture = newWeapon._img;
	_dmg =  newWeapon._dmg;
	_cooldown = newWeapon._atkSpeed;
	$Area3D/CollisionShape3D.shape.radius = 0.51;
	$Area3D/CollisionShape3D.shape.height = newWeapon._hitboxSize;


func _on_change_weapon(newWeapon:R_Weapon,dropPos:Vector3):
	var pickup = preload("res://Assets/Prefabs/objPickup.tscn");
	var pickupInstance:ObjPickup = pickup.instantiate();
	pickupInstance._weapon = _weaponActualStats;
	SetWeapon(newWeapon);
	Level.CreateObject(pickupInstance,dropPos);


func _on_area_3d_area_entered(area):
	if area.get_parent() != self.get_parent():
		_isHit = true;
		for node in area.get_parent().get_children():
			if node.has_signal("TakeDamage"):
				if node._actualHp >0 :
					node.emit_signal("TakeDamage",_weaponActualStats._dmg,_owner);
