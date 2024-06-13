extends ActionLeaf

var _actor;

func _process(delta):
	if(_actor!= null):
		_actor.MoveToTarget(Level.DELTA);

func tick(actor, blackboard: Blackboard):
	_actor = actor
	return SUCCESS
