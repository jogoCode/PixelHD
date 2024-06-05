extends Character
class_name PlayerCharacter

var _lookDir:Vector3;

func _physics_process(delta):
	super._physics_process(delta);
	if _stateMachine.GetState() == "Atk":
		_direction = Vector3.ZERO;
	if _direction:
		_lastDir = velocity;
		velocity.x = _direction.x * SPEED
		velocity.z = -_direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

#---------MY LOGIC--------------------------------------------------------------
func jump() -> void:
	if(is_on_floor()):
		velocity.y = JUMP_VELOCITY;

func Atk() -> void:
	_stateMachine.SetState("Atk");
