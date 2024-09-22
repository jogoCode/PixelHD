extends AtkSpe
class_name AtkSpeProjo

@export var _projo:PackedScene;
@export var _origin:Node3D;

func _ready() -> void:
	super._ready();


func _process(delta: float) -> void:
	if _isActive:
		_atkSpeTimer-=delta;
		_atkSpeTimer = clamp(_atkSpeTimer,0,1000);
		if _atkSpeTimer <=0.5:
			_isActive = false;

func action():
	super.action();
	if _owner._stateMachine.GetState() == "Atk":
		return;
	_projo = _owner._weapon._weaponActualStats._projo;
	if _projo == null:
		return;
	_owner.velocity = Vector3.ZERO;
	create_projectile();
	

func create_projectile():
	if !_isActive:
		canRemoveStamina();
		set_atkSpe_time.emit(1);
		_owner._stateMachine._stateAnimation.travel("Atk");
		_owner._stateMachine.combo += 1;
		_owner._stateMachine.combo = clamp(_owner._stateMachine.combo,0,3)
		_owner.applyImpulse(_owner.getPlayerLastDir()*3,15)
		var weapon = _owner._weapon;
		SoundFx.play(weapon.GetWeaponData()._audio,weapon.GetWeaponData()._atkSpeed*0.1);
		_owner._stateMachine.IsAtk();
		_owner._stateMachine.combo = 2;
		var projoInst:Projectile = _projo.instantiate();
		projoInst._dir = _owner.getPlayerLastDir();
		projoInst._owner = _owner; 
		projoInst.global_position = _origin.global_position;
		action_at_end();
		await get_tree().create_timer(0.2).timeout;
		_owner._stateMachine.combo = 3;
		Level.main.add_child(projoInst);
