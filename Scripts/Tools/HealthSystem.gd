extends Node
class_name HealthSystem;

@export var _baseHp:int;
var _actualHp:int;
var _maxHp:int;
var _canTakeDamage:bool = true;

@export var _destroyAtDeath:bool;

@onready var _owner = get_parent();

signal isDead();
signal TakeDamage(damage: int);


func _ready():
	_actualHp = _baseHp;
	_maxHp = _baseHp;

func AddActualHp(newHp:int)->void:
	if(_canTakeDamage):
		_actualHp += newHp;
		_actualHp = clampf(_actualHp,0,_maxHp);
		CanDeath();
		_canTakeDamage = false;
	
func CanDeath():
	if(_actualHp <= 0):
		if(_destroyAtDeath):
			_owner.queue_free();
			emit_signal("isDead");
		else:
			emit_signal("isDead");

func _on_take_damage(damage):
	var fx = preload("res://Prefabs/AnimatedFx.tscn");
	var FxInstance = fx.instantiate();
	Level.CreateObject(FxInstance,_owner.global_position,_owner.global_rotation);
	AddActualHp(-damage);
	Level._CAMERA.ShakeCamera(0.1*damage/4,0.1*damage/8);
	print(0.1*damage/4);
	await get_tree().create_timer(1).timeout;
	print(Engine.time_scale);
	_canTakeDamage = true;