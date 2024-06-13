extends Character
class_name PlayerCharacter

var _lookDir:Vector3;
var _playerOrientation:Vector3;
var _inputVector:Vector2;

func _physics_process(delta):
	super._physics_process(delta);
	if _stateMachine.GetState() == "Atk":
		velocity = Vector3(0,velocity.y,0)
	elif(_stateMachine.GetState() != "Hit"):
		_playerOrientation = Vector3(sign(_inputVector.x),0,sign(_inputVector.y));
		if _direction:
			_lastDir = _playerOrientation;
			#_lastDir = Vector3(sign(_direction.x),0,sign(_direction.z));
			velocity.x = _direction.x * SPEED
			velocity.z = _direction.z * SPEED
		else:
			velocity.x = 0;
			velocity.z = 0;

#---------MY LOGIC--------------------------------------------------------------

func jump()->void:
	if(is_on_floor()):
		velocity.y = JUMP_VELOCITY;

func Atk()->void:
	_stateMachine.IsAtk();

func GetPlayerOrientation()->Vector3:
	return _playerOrientation;
