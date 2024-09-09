extends Node
class_name HealthSystem;

@export var _baseHp:float;
var _actualHp:float;
var _maxHp:float;

@export var _armor:float;

var _canTakeDamage:bool = true;

@export var _destroyAtDeath:bool;

@onready var _owner = get_parent();

var fx = preload("res://Assets/Content/FX/AnimatedFx.tscn");
var slashFx = preload("res://Assets/Content/FX/Slash_Fx.tscn")
var bloodDrop = preload("res://Assets/Content/FX/Blood_drop.tscn");

signal isDead();
signal TakeDamage(damage,damager);


func _ready():
	setActualHp(_baseHp);
	setMaxHp(_baseHp);

func _physics_process(delta):
	if _canTakeDamage == false and _owner is Character:
		_owner.velocity.x = 0;
		_owner.velocity.z = 0;

func setMaxHp(value:float):
	_maxHp = value;

func setActualHp(value:float):
	_actualHp = value;

func AddActualHp(newHp:int)->void:
	_actualHp += newHp;
	_actualHp = clampf(_actualHp,0,_maxHp);
	CanDeath();
	_canTakeDamage = false;
	
func CanDeath():
	if(_actualHp <= 0):
		_owner._stateMachine.IsDie();
		if _owner is PlayerCharacter:
			Level.FreezeFrame(0.1,1);
			await get_tree().create_timer(1).timeout;
			Level.GameFinished.emit();
		elif _owner is EnemyCharacter:
			Level.MonsterKill.emit();
		emit_signal("isDead");

func FeedBack(damage,damager): #Feedback du loose HP
	var FxInstance = fx.instantiate();
	var BloodInstance = bloodDrop.instantiate();
	var SlashInstance = slashFx.instantiate();
	# sound fx
	SoundFx.play("Impact",0.1);
	# impact fx
	#Level.CreateObject(FxInstance,_owner.global_position);
	Level.CreateFx(SlashInstance,Vector3(_owner.global_position.x,0.5,_owner.global_position.z),Vector3.ZERO);
	await get_tree().create_timer(0.1).timeout;
	Level._CAMERA.ShakeCamera(0.05*damage/3,0.15);
	
	if(_owner is Character):
		if( damager !=null):
			# create blood fx
			print(damager.name)
			Level.CreateFx(BloodInstance,Vector3(_owner.global_position.x,0.5,_owner.global_position.z),damager.global_position,int(pow(damage,0.001)*pow(damage,0.8)));
			# apply damage impulse
			var impulseDir = Vector3(damager.getLastDir().x,0,damager.getLastDir().z);
			if _owner is PlayerCharacter:
				#for player character
				Level.FreezeFrame(0.2,0.2*damage/50);
				_owner.applyImpulse(impulseDir*damager.getLastDir().length()*(550)*Level.DELTA,4.5);
				for child in _owner.get_children():
					if child is Oscillator:
						child.add_velocity.emit(Oscillator.Modes.SCALE,2*damage);
			else:
				#for enemy character
				_owner.change_randnum()
				_owner.applyImpulse(impulseDir*damager.getLastDir().length()*(450)*Level.DELTA,4.5);
				Level.FreezeFrame(0.001,0.07);
				for child in _owner.get_children():
					if child is Oscillator:
						child.add_velocity.emit(Oscillator.Modes.ROTATION,2*damage);
			_owner.get_node("Visual/AnimatedSprite3D").modulate =Color(1,1,1,0.5);
			await get_tree().create_timer(0.1).timeout;
			_owner.get_node("Visual/AnimatedSprite3D").modulate =Color(1,1,1,1);
			# apply juice

func _on_take_damage(damage,damager):
	if(_owner is Character): #Chnage l'état du Character
		if _owner._stateMachine.GetState() == "Roll" or !_canTakeDamage :
			return;
		_canTakeDamage = false;
		# change hp
		AddActualHp(-damage);
		# feed back function
		FeedBack(damage,damager);
		# change state
		if _armor < 50:
			_owner._stateMachine.IsHit();
		await get_tree().create_timer(0.3).timeout;
		_canTakeDamage = true;
	else:
		FeedBack(damage,damager);
		AddActualHp(-damage);
