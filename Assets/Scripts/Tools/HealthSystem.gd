extends Node
class_name HealthSystem;

@export var _baseHp:float;
var _actualHp:float;
var _maxHp:float;

@export var _armor:float;

var _canTakeDamage:bool = true;

@export var _destroyAtDeath:bool;
@export var _canBeImpulse:bool = true;

@onready var _owner = get_parent();

var fx = preload("res://Assets/Content/FX/AnimatedFx.tscn");
var slashFx = preload("res://Assets/Content/FX/Slash_Fx.tscn")
var bloodDrop = preload("res://Assets/Content/FX/Blood_drop.tscn");

signal isDead();
signal TakeDamage(damage,damager);
signal hpChanged();
signal Heal(value);


func _ready():
	setActualHp(_baseHp);
	setMaxHp(_baseHp);
	Heal.connect(AddActualHp);

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
	if newHp <0:
		_canTakeDamage = false;
	hpChanged.emit();
	
func CanDeath() -> void: #TODO REMANIER ICI AUSSI
	if(_actualHp <= 0):
		if _owner is Character:
			_owner._stateMachine.IsDie();
		if _owner is PlayerCharacter: # Player Death
			Level.FreezeFrame(0.1,1);
			await get_tree().create_timer(1).timeout;
			Level.GameFinished.emit();
		elif _owner is EnemyCharacter:  # Enemy Death
			#spawn soul
			var soul = load("res://Assets/Content/soul.tscn").instantiate();
			soul.global_position.y = 1;
			_owner.get_parent().add_child(soul)
			soul.global_position = _owner.global_position;
			Level.MonsterKill.emit();
		emit_signal("isDead");

func FeedBack(damage,damager) -> void: #Hit Feedback;
	var FxInstance = fx.instantiate();
	var SlashInstance = slashFx.instantiate();
	# sound fx
	if damage >1:
		SoundFx.play("Impact",0.1);
	
	# impact fx
	Level.CreateFx(SlashInstance,Vector3(_owner.global_position.x,0.5,_owner.global_position.z),Vector3.ZERO);
	await get_tree().create_timer(0.1).timeout;
	Level._CAMERA.ShakeCamera(0.05*damage/3,0.15);
	
	# character Hit FeedBack
	if(_owner is Character):
		CharacterFeedBack(damage,damager);


func CharacterFeedBack(damage,damager) -> void:
	var BloodInstance = bloodDrop.instantiate();
	if( damager !=null):
		# create blood fx
		if damage >1:
			Level.CreateFx(BloodInstance,Vector3(_owner.global_position.x,0.5,_owner.global_position.z),damager.global_position,int(pow(damage,0.001)*pow(damage,0.8)));
		# apply damage impulse
		var impulseDir = Vector3(damager.getLastDir().x,0,damager.getLastDir().z);
		if _owner is PlayerCharacter:
			#for player character-----------------------
			PlayerCharacterFeedBack(damage,damager,impulseDir);
		else:
			#for enemy character-----------------------
			EnemyCharacterFeedBack(damage,damager,impulseDir)
		_owner.get_node("Visual/AnimatedSprite3D").modulate =Color(1,1,1,0.5);
		await get_tree().create_timer(0.1).timeout;
		_owner.get_node("Visual/AnimatedSprite3D").modulate =Color(1,1,1,1);
		# apply juice

func PlayerCharacterFeedBack(damage,damager,impulseDir)->void:
	#for player character-----------------------
	_owner.applyImpulse(impulseDir*damager.getLastDir().length()*5,4.5);
	for child in _owner.get_children():
		if child is Oscillator:
			child.add_velocity.emit(Oscillator.Modes.SCALE,2*damage);
	Level.FreezeFrame(0.2,0.2*damage/50);

func EnemyCharacterFeedBack(damage,damager,impulseDir)->void:
	#for enemy character------------------------
		if damage <1:
			#if weapon sharpness = 0
			SoundFx.play("BounceBlade");
			damager._stateMachine.IsAction("BladeBounce",0.2)
			var otherImpulseDir = Vector3(damager.getLastDir().x,0,damager.getLastDir().z);
			damager.applyImpulse(-otherImpulseDir*damager.getLastDir().length()*4,4.5);
			Level.FreezeFrame(0.1,0.2*damage/100);
			Level._CAMERA.ZoomCamera(3,0.35);
	
		_owner.change_randnum()
		if damage >1 and _canBeImpulse:
			_owner.applyImpulse(impulseDir*damager.getLastDir().length()*4,4.5);
		Level.FreezeFrame(0.001,0.07);
		for child in _owner.get_children():
			if child is Oscillator:
				child.add_velocity.emit(Oscillator.Modes.ROTATION,2*damage);
	

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
		if _armor < 50 and damage >2:
			_owner._stateMachine.IsAction("Hit",0.2);
		await get_tree().create_timer(0.3).timeout;
		_canTakeDamage = true;
	else:
		FeedBack(damage,damager);
		AddActualHp(-damage);
