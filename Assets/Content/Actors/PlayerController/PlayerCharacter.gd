extends Character
class_name PlayerCharacter

var _lookDir:Vector3;
var _playerOrientation:Vector3;
var _inputVector:Vector2;

@export var _weapon:Weapon;

func _physics_process(delta):
	super._physics_process(delta);
	
	if( _stateMachine.GetState() == "Atk01" or 
		_stateMachine.GetState() == "Atk02" or 
		_stateMachine.GetState() == "Atk03" or
		_stateMachine.GetState() == "Hit" or 
		_stateMachine.GetState() == "Die"):
		velocity = Vector3(0,velocity.y,0);
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
	if(_stateMachine.stateCheck()):
		return;
	_stateMachine.IsAction("Roll",0.5);
	Level._CAMERA.ZoomCamera(-1,0.1)
	var impulseDir;
	#jump();
	SoundFx.play("Roll",0.2);
	if(_inputVector.length() == 0):
		impulseDir = Vector3(_lastDir.x,0,-_lastDir.z);
	if(_inputVector.length() > 0):
		impulseDir = Vector3(_direction.x,0,_direction.z);
	applyImpulse(impulseDir*450*Level.DELTA,2);

func Atk()->void:
	#_stateMachine.IsAction("Atk",0.1);
	if(_stateMachine.stateCheck()):
		return;
	Level._CAMERA.ZoomCamera(-1,0.1)
	SoundFx.play(_weapon.GetWeaponData()._audio,_weapon.GetWeaponData()._atkSpeed*0.1);
	var impulseDir = Vector3(getLastDir().x,0,-getLastDir().z);
	if(_inputVector.length() == 0): 
		impulseDir = Vector3(_lastDir.x,0,-_lastDir.z);
	if(_inputVector.length() > 0):
		impulseDir = Vector3(_direction.x,0,_direction.z);
	applyImpulse(impulseDir*350*Level.DELTA,3.5);
	_stateMachine.IsAtk();
	return;
	for child in get_children():
		if child is Oscillator:
			child.add_velocity.emit(Oscillator.Modes.SCALE,35);


func GetPlayerOrientation()->Vector3:
	return _playerOrientation;

