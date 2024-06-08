extends Character
class_name PlayerCharacter

var _lookDir:Vector3;
var _playerOrientation:Vector3;
var _inputVector;

func _physics_process(delta):

	if _stateMachine.GetState() == "Atk":
		_direction = Vector3.ZERO;
	else:
		super._physics_process(delta);
		_inputVector = Input.get_vector("ui_left","ui_right","ui_down","ui_up",0);
		_playerOrientation = Vector3(sign(_inputVector.x),0,sign(_inputVector.y));
		if _direction:
			_lastDir = _direction;
			velocity.x = _direction.x * SPEED
			velocity.z = _direction.z * SPEED
		else:
			velocity.x = 0;
			velocity.z = 0;
			#velocity.x = move_toward(velocity.x, 0, SPEED*2)
			#velocity.z = move_toward(velocity.z, 0, SPEED*2)		

#---------MY LOGIC--------------------------------------------------------------

func jump() -> void:
	if(is_on_floor()):
		velocity.y = JUMP_VELOCITY;

func Atk() -> void:
	_stateMachine.SetState("Atk");

func GetPlayerOrientation()->Vector3:
	return _playerOrientation;
