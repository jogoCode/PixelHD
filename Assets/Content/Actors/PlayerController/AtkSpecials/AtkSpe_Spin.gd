extends AtkSpe
class_name AtkSpeSpin

func _ready() -> void:
	set_atkSpe_time.connect(_set_atkSpe_time);

func _process(delta: float) -> void:
	if _owner._stateMachine.GetState() == "Spin":
		process_mode = PROCESS_MODE_ALWAYS;
		_atkSpeTimer-=delta;
		_atkSpeTimer = clamp(_atkSpeTimer,0,1000);
		if _atkSpeTimer <= 0 and _isActive :
			process_mode = PROCESS_MODE_INHERIT;
			action_at_end();
			_isActive = false;

func action():
	super.action();
	if _owner._stateMachine.GetState() != "Spin":
		_owner._stateMachine.IsAction("AtkSpe",0.1);
		_owner._stateMachine._animationTree["parameters/AtkSpe/conditions/isSpin"] = true;
		set_atkSpe_time.emit(0.5);
		#---stamina cost
		_owner._staminaSys.remove_stamina.emit(_staminaCost);

func action_at_end():
	var weapon = _owner._weapon;
	await get_tree().create_timer(0.2).timeout
	_owner._stateMachine._stateAnimation.travel("Atk");
	_owner._stateMachine.combo = 3;
	_owner.applyImpulse(_owner.getPlayerLastDir()*3,15)
	SoundFx.play(weapon.GetWeaponData()._audio,weapon.GetWeaponData()._atkSpeed*0.1);
	_owner._stateMachine.IsAtk();
	_owner._stateMachine._animationTree["parameters/AtkSpe/conditions/isSpin"] = false;
	#_owner.Atk();

func _set_atkSpe_time(value:float)->void:
	_isActive = true;
	_atkSpeTimer = value;
