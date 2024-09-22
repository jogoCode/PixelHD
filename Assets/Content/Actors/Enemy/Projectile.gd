extends Area3D
class_name Projectile

var _owner:Character;
@export var _SPEED:float = 5;
@export var _accel:float = 2;
@export var _canAccelerate:bool;
@export var _damage:float = 15;
@export var _dir:Vector3;
@export var _delayToDestroy:float = 5;
@export var _destroyAtTouch:bool = true;
@export var _hideAtTouch:bool = true;
@export var _lookAtDir:bool = false;

@export var _visual:Node3D;
@export var _audio:String;
var _vel:Vector3;
@onready var _collision:CollisionShape3D = get_node("CollisionShape3D");

var _ownerType:Ownertypes;

enum Ownertypes{
	PLAYER,
	ENEMY,
	BOTH
}

var _targPossible;
func _ready():
	area_entered.connect(_on_area_entered);
	set_owner_type();
	if _audio:
		SoundFx.play(_audio);
	await get_tree().create_timer(_delayToDestroy).timeout;
	stop_projo()

func set_owner_type()->void:
	if _owner is PlayerCharacter:
		_ownerType = Ownertypes.PLAYER;
	if _owner is EnemyCharacter:
		_ownerType = Ownertypes.ENEMY;

func _physics_process(delta: float):
	translate(Vector3(_dir.x,0,_dir.z)*delta*_SPEED);
	_vel = Vector3(_dir.x,0,_dir.z)*delta*_SPEED;
	if _canAccelerate:
		_SPEED = lerp(_SPEED,_SPEED*_accel,delta);
	if _lookAtDir:
		if _visual:
			_visual.look_at(global_position+-_dir);
	
func stop_projo():
	_collision.disabled = true;
	_SPEED = 0;
	if _visual != null:
		for node in _visual.get_children():
			if node is GPUParticles3D:
				node.emitting = false;
			if node is Sprite3D: 
				node.hide();
		await get_tree().create_timer(0.5).timeout;
		queue_free();
	else:
		queue_free();

func _on_area_entered(area):	
	if area.get_parent() == _owner:
		return;
	if area is Projectile:
		stop_projo();
		print(_owner.name,":",area._collision.disabled);
		return;
		
	if _ownerType == Ownertypes.ENEMY:
			if area.get_parent() is EnemyCharacter:
				return;
	if area.get_parent() != _owner and area.name == "HurtBox":
		for node in area.get_parent().get_children():
			if node.has_signal("TakeDamage"):
				node.emit_signal("TakeDamage",_damage,self);
				if _hideAtTouch:
					hide();
				await get_tree().create_timer(0.1).timeout;
				if _destroyAtTouch:
					queue_free();
				return; # Replace with function body.
