extends ActionLeaf

var _actor;

func _process(delta):
	if(_actor!= null):
		_actor.MoveToTarget(Level.DELTA);

func tick(actor, blackboard: Blackboard):
	if actor._stateMachine.GetState() == "Die":
		return FAILURE;
	actor._stateMachine._animationTree["parameters/Move/Blend2/blend_amount"] = 0;
	_actor = actor
	return SUCCESS
