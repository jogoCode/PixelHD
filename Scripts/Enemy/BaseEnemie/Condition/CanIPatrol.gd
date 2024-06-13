extends ConditionLeaf


func tick(actor, blackboard: Blackboard):
	if(!actor.IsInImpulse()):
		return SUCCESS
	else:
		return FAILURE

