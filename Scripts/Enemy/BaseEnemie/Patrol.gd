extends ActionLeaf

var _delta;

func _physics_process(delta):
	_delta = delta;

func tick(actor, blackboard: Blackboard):
	actor._HitBox.disabled = true;
	if(_delta != null):
		actor.MoveToDirection(RandDir(),_delta);
	return SUCCESS

func RandDir()->Vector3:
	var randBool = randi_range(0,3);
	var randDir = Vector3(randi_range(-1,1),0,randi_range(-1,1));
	if(randBool>0):
		return randDir;
	else:
		return Vector3.ZERO;
