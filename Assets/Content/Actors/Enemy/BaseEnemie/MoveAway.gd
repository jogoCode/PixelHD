extends ActionLeaf


func tick(actor, blackboard: Blackboard):
	actor._stateMachine._animationTree["parameters/Move/Blend2/blend_amount"] = 1;
	#actor.TurnAroundTarget();
	actor.MoveAwayToTarget(Level.DELTA);
	actor.get_node("Label3D").text =  "RECULE"
	return SUCCESS;
