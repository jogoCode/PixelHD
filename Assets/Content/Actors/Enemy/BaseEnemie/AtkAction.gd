extends ActionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	actor._stateMachine.IsAtk();
	return SUCCESS
