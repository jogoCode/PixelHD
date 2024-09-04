extends AnimationManager

@onready var _owner:EnemyCharacter = get_parent();

func _physics_process(delta):
	var stateAnimation = _stateAnimation;
	var lastVel = _character.getLastDir();
	var vel:Vector3;


	vel = _character.velocity;
	if _owner._stateMachine.GetState() == "Die":
		_animationTree["parameters/Die/Die/blend_position"] = lastVel.x;
		return;
	if _owner._target != null:
		_animationTree["parameters/Move/Move/blend_position"] = Vector2(vel.x,-vel.z);
		#var targetPostion = _owner._target.global_position;
		_animationTree["parameters/Move/MoveBck/blend_position"] = Vector2(vel.x,-vel.z);
	if _owner._stateMachine.GetState() == "Atk":
		_animationTree["parameters/Pre_Atk/blend_position"] = Vector2(_owner.global_position.direction_to(_owner._target.global_position).x,vel.z);
	_animationTree["parameters/Atk/blend_position"] = Vector2(lastVel.x,vel.z);
