extends Character
class_name PlayerCharacter

var _lookDir:Vector3;
var _playerOrientation:Vector3;
var _inputVector:Vector2;

func _physics_process(delta):
	super._physics_process(delta);
	if _stateMachine.GetState() == "Atk01" or _stateMachine.GetState() == "Atk02":
		velocity = Vector3(0,velocity.y,0)
	elif(_stateMachine.GetState() != "Hit" and 
		_stateMachine.GetState() != "Roll" and 
		_stateMachine.GetState() != "EndRoll"):
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
		velocity.y = JUMP_VELOCITY/2;

func Roll()->void:
	if(_stateMachine.GetState() == "Roll" or 
	_stateMachine.GetState() == "Atk01" or
	_stateMachine.GetState() == "EndRoll"or
	_stateMachine.GetState() == "Atk02"):
		return;
	var impulseDir;
	jump();
	if(_inputVector.length() == 0):
		impulseDir = Vector3(_lastDir.x,0,-_lastDir.z);
	if(_inputVector.length() > 0):
		impulseDir = Vector3(_direction.x,0,_direction.z);
	applyImpulse(impulseDir*600*Level.DELTA,2.5);
	_stateMachine.IsAction("Roll",0.1);

func Atk()->void:
	#_stateMachine.IsAction("Atk",0.1);
	if(_stateMachine.GetState() == "Atk01" or 
	_stateMachine.GetState() == "Roll"or
	_stateMachine.GetState() == "EndRoll" or
	_stateMachine.GetState() == "Atk02"):
		return;
	SoundFx.play("Slash");
	var impulseDir = Vector3(getLastDir().x,0,-getLastDir().z);
	if(_inputVector.length() == 0): 
		impulseDir = Vector3(_lastDir.x,0,-_lastDir.z);
	if(_inputVector.length() > 0):
		impulseDir = Vector3(_direction.x,0,_direction.z);
	applyImpulse(impulseDir*350*Level.DELTA,3.5);
	_stateMachine.IsAtk();


func GetPlayerOrientation()->Vector3:
	return _playerOrientation;
