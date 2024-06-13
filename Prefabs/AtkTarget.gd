extends ActionLeaf


func tick(actor, blackboard: Blackboard):
	if(actor != null):
		actor.applyImpulse(actor.velocity.normalized()*10);
		actor._stateMachine.IsAtk();
		actor._stateMachine._canAtk = true;	
	return SUCCESS

