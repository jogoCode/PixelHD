extends Node
class_name HealthSystem;

@export var _baseHp:int;
var _actualHp:int;
var _maxHp:int;
var _canTakeDamage:bool = true;

@export var _destroyAtDeath:bool;

@onready var _owner = get_parent();

signal isDead();
signal TakeDamage(damage: int,damager);


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

func FeedBack(damage,damager): #Feedback du loose HP
	var fx = preload("res://Prefabs/FX/AnimatedFx.tscn");
	var FxInstance = fx.instantiate();
	Level.CreateObject(FxInstance,_owner.global_position,_owner.global_rotation);
	Level._CAMERA.ShakeCamera(0.2*damage/4,0.1*damage/8);
	if(_owner is Character):
		if(_owner.IsInImpulse() != true):
			_owner.applyImpulse(500*Vector3(damager.getLastDir().x*Level.DELTA,0,-damager.getLastDir().z),3.5);

func _on_take_damage(damage,damager):
	if(_owner is Character): #Chnage l'état du Character
		if(_owner._stateMachine._actualState != "Hit"):
			FeedBack(damage,damager);
			AddActualHp(-damage);
			_owner._stateMachine.IsHit();
			await get_tree().create_timer(1).timeout;
			_canTakeDamage = true;
	else:
		FeedBack(damage,damager);
		AddActualHp(-damage);
