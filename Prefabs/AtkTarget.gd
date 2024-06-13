extends ActionLeaf


func tick(actor, blackboard: Blackboard):
	actor.applyImpulse(actor.velocity.normalized()*10);
	actor._HitBox.disabled = false;
	actor._stateMachine.IsAtk();
	actor._stateMachine._canAtk = true;	
	return SUCCESS

