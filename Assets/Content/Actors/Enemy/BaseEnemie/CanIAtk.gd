extends ConditionLeaf


func tick(actor, blackboard: Blackboard):
	if(actor._stateMachine._actualState == "Hit"):
		return FAILURE

	if actor.RayTouchTarget():
		actor._stateMachine.IsAtk();
		return SUCCESS
	if(actor.global_position.distance_to(actor._target.global_position) <= actor._atkRange and 
	actor.global_position.distance_to(actor._target.global_position) >= actor._atkRange/1.1):
		if actor._canAtk:
			actor._stateMachine.IsAtk();
			return SUCCESS
		return FAILURE
	else:
		return FAILURE
