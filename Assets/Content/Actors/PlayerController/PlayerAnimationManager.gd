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
			_animationTree["parameters/Idle/blend_position"] = lastVel.x;
			_animationTree["parameters/Walk/blend_position"] = vel.x;
			_animationTree["parameters/Roll/blend_position"] = vel.x;
			_animationTree["parameters/EndRoll/blend_position"] = vel.x;
			_animationTree["parameters/BladeBounce/BladeBounce/blend_position"] = vel.x;
			_animationTree["parameters/Atk01/Atk_01/blend_position"] = vel.x;
			_animationTree["parameters/Atk01/Atk_01_H/blend_position"] = vel.x;
			_animationTree["parameters/Atk02/Atk_02/blend_position"] = vel.x;
			_animationTree["parameters/Atk02/Atk_02_H/blend_position"] = vel.x;
			_animationTree["parameters/Atk03/Atk_03/blend_position"] = vel.x;
			_animationTree["parameters/Atk03/Atk_03_H/blend_position"] = vel.x;
	if _character._impulseVelocity.x > 0:	
		_animationTree["parameters/Hit/blend_position"] = 1;
	elif _character._impulseVelocity.x < 0:	
		_animationTree["parameters/Hit/blend_position"] = -1;

func set_atk_type(type):
	match type:
		R_Weapon.Type.LIGHT:
			_animationTree["parameters/Atk01/Blend2/blend_amount"] = 0;
			_animationTree["parameters/Atk02/Blend2/blend_amount"] = 0;
			_animationTree["parameters/Atk03/Blend2/blend_amount"] = 0;
		R_Weapon.Type.HEAVY:
			_animationTree["parameters/Atk01/Blend2/blend_amount"] = 1;
			_animationTree["parameters/Atk02/Blend2/blend_amount"] = 1;
			_animationTree["parameters/Atk03/Blend2/blend_amount"] = 1;


func _on_weapon_change_weapon(newWeapon,sharpness,dropPos):
	if newWeapon == null:
		return;
	_animSpeed = newWeapon._atkSpeed;
	set_atk_type(newWeapon._type);
	_animationTree["parameters/Atk01/TimeScale/scale"] = _animSpeed;
	_animationTree["parameters/Atk02/TimeScale/scale"] = _animSpeed;
	_animationTree["parameters/Atk03/TimeScale/scale"] = _animSpeed;
