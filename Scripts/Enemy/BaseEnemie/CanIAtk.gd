extends ConditionLeaf


func tick(actor, blackboard: Blackboard):
	actor.velocity = Vector3.ZERO;
	if(actor._stateMachine._actualState == "Hit"):
		return FAILURE
	if(actor.global_position.distance_to(actor._target.global_position) <= actor._atkRange):
		return SUCCESS
	else:
		return FAILURE
