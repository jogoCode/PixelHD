extends ConditionLeaf


func tick(actor, blackboard: Blackboard):
	if(actor.global_position.distance_to(actor._target.global_position) <= actor._atkRange
	and actor._stateMachine._actualState != "Hit"):
		return SUCCESS
	else:
		return FAILURE
