extends AnimationManager

func _physics_process(delta):
	var stateAnimation = _stateAnimation;
	var lastVel = _character.getLastDir();
	var vel:Vector3;

	if(_character is PlayerCharacter):
		vel= _character._playerOrientation;
		if vel.length() > 0.9:
			if(lastVel == Vector3(1,0,0) || lastVel == Vector3(-1,0,0) ):
				lastVel.z = 0;
			if(lastVel == Vector3(0,0,1) || lastVel == Vector3(0,0,-1)):
				lastVel.x = 0;
			match _character._stateMachine.GetState():
				"Idle":
					_animationTree["parameters/Idle/blend_position"] = lastVel.x;
				"Walk":
					_animationTree["parameters/Walk/blend_position"] = vel.x;
			_animationTree["parameters/BladeBounce/BladeBounce/blend_position"] = vel.x;	
			var _type = _character._stateMachine._weaponType;
			_animationTree["parameters/Roll/blend_position"] = vel.x;
			_animationTree["parameters/EndRoll/blend_position"] = vel.x;
			_animationTree["parameters/Atk/"+_type+"/Atk01/Atk01/blend_position"] = vel.x;
			_animationTree["parameters/Atk/"+_type+"/Atk02/Atk02/blend_position"] = vel.x;
			_animationTree["parameters/Atk/"+_type+"/Atk03/Atk03/blend_position"] = vel.x;
	if _character._impulseVelocity.x > 0:	
		_animationTree["parameters/Hit/blend_position"] = 1;
	elif _character._impulseVelocity.x < 0:	
		_animationTree["parameters/Hit/blend_position"] = -1;

func set_atk_type(type):
	match type:
		R_Weapon.Type.LIGHT:
			_character._stateMachine._weaponType = "Light";
		R_Weapon.Type.HEAVY:
			_character._stateMachine._weaponType = "Heavy";


func _on_weapon_change_weapon(newWeapon,sharpness,dropPos):
	if newWeapon == null:
		return;
	_animSpeed = newWeapon._atkSpeed;
	set_atk_type(newWeapon._type);
	var _type = _character._stateMachine._weaponType;
	_animationTree["parameters/Atk/"+_type+"/Atk01/TimeScale/scale"] = _animSpeed;
	_animationTree["parameters/Atk/"+_type+"/Atk02/TimeScale/scale"] = _animSpeed;
	_animationTree["parameters/Atk/"+_type+"/Atk03/TimeScale/scale"] = _animSpeed;
