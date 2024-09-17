extends ConditionLeaf


func tick(actor, blackboard: Blackboard):
	if(actor._stateMachine._actualState == "Hit"):
		return FAILURE
	if actor.RayTouchTarget() and actor._mood == 1:
		return SUCCESS
	else:
		#if(actor.global_position.distance_to(actor._target.global_position) <= actor._atkRange and 
		if(actor._navAgent.target_position.distance_to(actor.global_position) <= 0.5):
		#actor.global_position.distance_to(actor._target.global_position) >= actor._atkRange/1.5):	
			return SUCCESS
		else:
			return FAILURE
	return FAILURE
