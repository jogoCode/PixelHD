extends ConditionLeaf


func tick(actor, blackboard: Blackboard):
	if(actor._stateMachine._actualState == "Hit"):
		return FAILURE
	if(actor.global_position.distance_to(actor._target.global_position) <= actor._atkRange and 
	actor.global_position.distance_to(actor._target.global_position) >= actor._atkRange-2):
		if actor._canAtk:
			actor._stateMachine.IsAtk();
			return SUCCESS
		return FAILURE
	else:
		return FAILURE
