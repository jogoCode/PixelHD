extends ActionLeaf


func tick(actor, blackboard: Blackboard):
	#actor.velocity = Vector3.ZERO;
	return SUCCESS
	if(actor != null):
		actor.Atk();
		return SUCCESS
	return FAILURE;

