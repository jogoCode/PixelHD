extends ConditionLeaf


func tick(actor, blackboard: Blackboard):
	if(actor._target!=null):
		return SUCCESS
	else:
		return FAILURE;

