extends ActionLeaf


func tick(actor, blackboard: Blackboard):
	actor.velocity = Vector3.ZERO;
	if(actor != null):
		actor.applyImpulse(actor.velocity.normalized()*15,5);
		actor._stateMachine.IsAtk();
	return SUCCESS

