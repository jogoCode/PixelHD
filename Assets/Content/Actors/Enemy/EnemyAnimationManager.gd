extends AnimationManager

@onready var _owner:EnemyCharacter = get_parent();


func _physics_process(delta):
	var stateAnimation = _stateAnimation;
	var lastVel = _character.getLastDir();
	var vel:Vector3;


	vel = _character.velocity;
	if _owner._stateMachine.GetState() == "Die":
		var dieVel = _character.getLastDir();
		_animationTree["parameters/Die/Die/blend_position"] = dieVel.x;
		return;
	if _owner._target != null:
		_animationTree["parameters/Move/Move/blend_position"] = Vector2(vel.x,-vel.z);
		#var targetPostion = _owner._target.global_position;
		_animationTree["parameters/Move/MoveBck/blend_position"] = Vector2(vel.x,-vel.z);
	if _owner._stateMachine.GetState() == "Pre_Atk":
		var targetDir = _owner.GetTargetDirection();
		_animationTree["parameters/Pre_Atk/blend_position"] = Vector2(_owner.GetTargetDirection().x,vel.z);
	
	
	if _owner._atk is AtkMelee:
		_animationTree["parameters/Atk/blend_position"] = Vector2(lastVel.x,vel.z);
	if _owner._atk is DistAtk:
		_animationTree["parameters/Atk/blend_position"] = Vector2(_owner.GetTargetDirection().x,vel.z);
	_animationTree["parameters/Hit/blend_position"] = Vector2(-lastVel.x,lastVel.z);
