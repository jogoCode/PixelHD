extends Area3D
class_name Projectile

var _owner:Character;
@export var _SPEED:float = 5;
@export var _canAccelerate:bool;
@export var _damage:float = 15;
@export var _dir:Vector3;
@export var _delayToDestroy:float = 5;
@export var _destroyAtTouch:bool = true;
@export var _hideAtTouch:bool = true;
@export var _lookAtDir:bool = false;
@export var _visual:Node3D;
var _vel:Vector3;
@onready var _collision:CollisionShape3D = $CollisionShape3D;

var _targPossible;
func _ready():
	area_entered.connect(_on_area_entered);
	if _owner is PlayerCharacter:
		_targPossible = 0
	if _owner is EnemyCharacter:
		_targPossible = 1;
	await get_tree().create_timer(_delayToDestroy).timeout;
	stop_projo()
	
func _physics_process(delta: float):
	translate(Vector3(_dir.x,0,_dir.z)*delta*_SPEED);
	_vel = Vector3(_dir.x,0,_dir.z)*delta*_SPEED;
	if _canAccelerate:
		_SPEED = lerp(_SPEED,_SPEED*2,delta*2);
	if _lookAtDir:
		_visual.look_at(global_position+-_dir);
	
func stop_projo():
	_collision.disabled = true;
	if _visual != null:
		for node in _visual.get_children():
			if node is GPUParticles3D:
				node.emitting = false;
		await get_tree().create_timer(_delayToDestroy).timeout;
		queue_free();
	else:
		queue_free();

func _on_area_entered(area):	
	var targetType:Character;
	if area.get_parent() == _owner:
		return;
	if area is Projectile:
		stop_projo();
		print("POTO");
		return;
	if _owner is EnemyCharacter:
		if area.get_parent() is EnemyCharacter:
			return;
	if area.get_parent() != _owner and area.name == "HurtBox":
		for node in area.get_parent().get_children():
			if node.has_signal("TakeDamage"):
				node.emit_signal("TakeDamage",_damage,self);
				if area.get_parent()._stateMachine.GetState() != "Roll":
					if _hideAtTouch:
						hide()
					await get_tree().create_timer(0.1).timeout;
					if _destroyAtTouch:
						queue_free();
				return; # Replace with function body.
