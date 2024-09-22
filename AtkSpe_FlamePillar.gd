extends AtkSpeProjo
class_name AtkSpeFlameBigBlade

func _ready() -> void:
	super._ready();


func action():
	super.action();

func create_projectile():
	if _owner._stateMachine.GetState() == "BigBlade":
		return
	if !_isActive:
		canRemoveStamina();
		set_atkSpe_time.emit(2);
		_owner._stateMachine._stateAnimation.travel("AtkSpe");
		_owner._stateMachine._animationTree["parameters/AtkSpe/conditions/isBigBlade"] = true;
		_owner._stateMachine.combo = 3;
		_owner.applyImpulse(_owner.getPlayerLastDir()*3,15)
		_owner.get_node("HealthSystem")._armor = 50;
		var weapon = _owner._weapon;
				#Blade of flame
		var projoInst:Projectile = _projo.instantiate();
		projoInst._owner = _owner;
		SoundFx.play("StartFlameBigBlade");
		_owner._weapon.get_node("origin").add_child(projoInst);
		#Level._CAMERA.ZoomCamera(15,1);
		await get_tree().create_timer(0.1).timeout;
		SoundFx.play(weapon.GetWeaponData()._audio,weapon.GetWeaponData()._atkSpeed*0.1);
		Level.FreezeFrame(0.1,0.25);
		Level._CAMERA.ShakeCamera(1,4);
		await get_tree().create_timer(1).timeout;
		_owner.get_node("HealthSystem")._armor = 0;
		action_at_end();
		#Pillar of flame----------------------------------------
		#for i in range(3):
			#await get_tree().create_timer(0.15).timeout;
			#Level._CAMERA.ShakeCamera(0.1,0.15);
			#Level.FreezeFrame(0.2,0.05);
			#var projoInst:Projectile = _projo.instantiate();
			#projoInst._owner = _owner;
			#_owner._stateMachine.combo = 3;
			#Level.main.add_child(projoInst);
			#array.insert(i,projoInst);
			#projoInst._dir = direction;
			#projoInst.global_position = _origin.global_position;
			#projoInst.global_position+=projoInst._dir*i*0.8;
			#projoInst.position.y = _owner.position.y;

func action_at_end():
	super.action_at_end();
	_owner._stateMachine._animationTree["parameters/AtkSpe/conditions/isBigBlade"] = false;
