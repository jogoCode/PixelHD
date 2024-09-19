extends Node3D
class_name Weapon;

@export var _owner:Character;

var direction;
var inputVector;

@export var _sharpness:float;
@export var _usageSharpness:float = 2;

@export var _weaponActualStats:R_Weapon;
@export var _sprite:Sprite3D;
@export var _hitBox:CollisionShape3D;
@export var _slashSfx:AnimatedSprite3D;

# ajouter la création du pickup 

var _dmg:int;
var _cooldown:float;
var _hitBoxTime:float;
var _isHit:bool;

# the num off anim to sharpen
var _numSharpenAnim:int = 4;
# actual sharpen anim
var _sharpenAnim:int = 0;

signal ChangeWeapon(newWeapon:R_Weapon,sharpness:float,dropPos:Vector3);
signal AtkFinished();
signal sharpnesChanged();


func _ready():
	$Spark.emitting = false;
	rotation_degrees = Vector3(-45,0,-11.6);
	await  get_tree().create_timer(0.5).timeout;
	SetWeapon(_weaponActualStats,100);
	_owner._stateMachine.StateChanged.connect(_reset_sharpenAnim);


func _physics_process(delta):
	if(_owner._stateMachine.GetState() == "Atk" or 
		_owner._stateMachine.GetState() == "AtkSpe" or 
	   _owner._stateMachine.GetState() == "Sharpen" or
	 _owner._stateMachine.GetState() == "EndSharpen" or
	   _owner._stateMachine.GetState() == "BladeBounce"):
			#await  get_tree().create_timer(_cooldown).timeout;
			show();
			if (_weaponActualStats!= null):
				_slashSfx.modulate = _weaponActualStats._fxColor;
			#_owner._stateMachine._animationTree["parameters/conditions/isAtk"] = false; 
			if _isHit != false:
				return;
				_hitBox.disabled = true;
	else:
		hide();
		_hitBox.disabled = true;
		_isHit = false;
		emit_signal("AtkFinished");
	HitBoxOrientation();

func  HitBoxOrientation():
	var area3d = _hitBox.get_parent();
	if _owner.GetPlayerOrientation().x >0:
		area3d.rotation_degrees = Vector3(45,5,5);
	if _owner.GetPlayerOrientation().x <0:
		area3d.rotation_degrees = Vector3(-45,180,-11);
	#match _owner.GetPlayerOrientation():
		#Vector3(1,0,0): #Right
			#area3d.rotation_degrees = Vector3(45,5,5);
		#Vector3(-1,0,0): #Left
			#area3d.rotation_degrees = Vector3(-45,180,-11);

func GetWeaponData():
	return _weaponActualStats;

func ActiveHitBox(timeToDisable):
	_hitBox.disabled = false;
	await get_tree().create_timer(timeToDisable).timeout;
	_hitBox.disabled = true;

func SetWeapon(newWeapon:R_Weapon,sharpness):
	if newWeapon == null:
		return;
	_sharpness = sharpness;
	_weaponActualStats = newWeapon;
	_sprite.texture = newWeapon._img;
	_dmg =  newWeapon._dmg;
	_cooldown = newWeapon._atkSpeed;
	_sprite.shaded = newWeapon._shaded;
	$Area3D/CollisionShape3D.shape.radius = 0.51;
	$Area3D/CollisionShape3D.shape.height = newWeapon._hitboxSize;
	sharpnesChanged.emit();

func GetWeaponType()->String:
	match _weaponActualStats._type:
		0:
			return "Light";
		1:
			return "Heavy";
	return "null";

func reduce_sharpenAnim(value):
	_numSharpenAnim-=value;
	_numSharpenAnim = clamp(_numSharpenAnim,1,6);
	
func _reset_sharpenAnim():
	_sharpenAnim = 0

func _add_sharpness():
	_sharpenAnim += 1;
	if _sharpenAnim == _numSharpenAnim:
		_sharpness = 100;
		sharpnesChanged.emit();
		_owner._stateMachine._stateAnimation.travel("Idle");

func _use_sharpness():
	_sharpness-=_usageSharpness;
	_sharpness = clamp(_sharpness,0,100);
	sharpnesChanged.emit();


func _on_change_weapon(newWeapon:R_Weapon,sharpness,dropPos:Vector3):
	var lastWeapon
	if _weaponActualStats != null:
		var pickup = preload("res://Assets/Prefabs/objPickup.tscn");
		var pickupInstance:ObjPickup = pickup.instantiate();
		pickupInstance._weapon = _weaponActualStats;
		pickupInstance._sharpness = _sharpness;
		Level.CreateObject(pickupInstance,dropPos);
		if dropPos == Vector3.DOWN:
			pickupInstance.queue_free();
	SetWeapon(newWeapon,sharpness);


func _on_area_3d_area_entered(area):
	if area.get_parent() != self.get_parent():
		_isHit = true;
		for node in area.get_parent().get_children():
			if node.has_signal("TakeDamage"):
				if node._actualHp >0 :
					_use_sharpness();
					if _sharpness >0:
						node.emit_signal("TakeDamage",_weaponActualStats._dmg,_owner);
					else:
						node.emit_signal("TakeDamage",0,_owner);
