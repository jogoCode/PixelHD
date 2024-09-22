extends Character
class_name PlayerCharacter

var _lookDir:Vector3;
var _playerOrientation:Vector3;
var _inputVector:Vector2;

@export var _weapon:Weapon;
@export var _atkSpeLib:Node;
var _delta;
var _staminaSys:StaminaSystem;

func _ready() -> void:
	if !_atkSpeLib:
		printerr("no atkspe lib");
		
	for node in get_children():
		if node.has_signal("remove_stamina"):
			_staminaSys = node;

func _process(delta: float) -> void:
	$debug.text = _stateMachine.GetState();
	_delta = delta;

func _physics_process(delta):
	super._physics_process(delta);
	$cursor.look_at(position+getPlayerLastDir());
	if( _stateMachine.GetState() == "Atk" or 
		_stateMachine.GetState() == "Hit" or 
		_stateMachine.GetState() == "Die" or
		_stateMachine.GetState() == "Sharpen" or
		_stateMachine.GetState() == "EndSharpen" or
		_stateMachine.GetState() == "BladeBounce" or 
		_stateMachine.GetState() == "BigBlade" ):
		velocity = Vector3(0,velocity.y,0);
	elif(_stateMachine.GetState() != "Hit" and
		_stateMachine.GetState() != "Roll" and 
		_stateMachine.GetState() != "EndRoll"):
		_playerOrientation = Vector3(sign(_inputVector.x),0,sign(_inputVector.y)).normalized();
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
	if(_stateMachine.stateCheck() or
		_stateMachine.GetState() == "Spin"):
		return;
	if !_staminaSys._can_use_stamina():
		return;
	_staminaSys.remove_stamina.emit(10);
	_stateMachine.IsAction("Roll",0.5);
	Level._CAMERA.ZoomCamera(-1,0.1)
	SoundFx.play("Roll",0.2);
	var impulseDir = getPlayerLastDir();
	applyImpulse(impulseDir*4,2);

func Atk()->void:
	if _weapon._weaponActualStats == null:
		return;
	if(_stateMachine.stateCheck() or 
	   _stateMachine.GetState() == "Sharpen" or
	   _stateMachine.GetState() == "Spin"):
		return;
	Level._CAMERA.ZoomCamera(-1,0.1);
	SoundFx.play(_weapon.GetWeaponData()._audio,_weapon.GetWeaponData()._atkSpeed*0.1);
	var impulseDir = getPlayerLastDir();
	applyImpulse(impulseDir*3,3.5);
	_stateMachine.IsAtk();

func AtkSpe()->void:
	if _weapon._weaponActualStats == null:
		return;
	if( _stateMachine.GetState() == "Roll" or 
		_stateMachine.GetState() == "EndRoll" or 
		_stateMachine.GetState() == "Hit"):
		return;
	
	if	_atkSpeLib.get_child(_weapon._weaponActualStats._atkSpe)!=null:
		var atkSpe:AtkSpe = _atkSpeLib.get_child(_weapon._weaponActualStats._atkSpe);
		if !_staminaSys._can_use_stamina(atkSpe._staminaCost):
			return;
		atkSpe.action();

	
func Sharpen():
	if(_stateMachine.stateCheck()):
		return;
	if _weapon._sharpness<100:
		_stateMachine.IsAction("Sharpen",0.2);


func GetHp():
	return $HealthSystem._actualHp;

func getPlayerLastDir()->Vector3:
	var vect = Vector3(getLastDir().x,0,-getLastDir().z);
	if(_inputVector.length() == 0): 
		vect =  Vector3(_lastDir.x,0,-_lastDir.z);
	if(_inputVector.length() > 0):
		vect =  Vector3(_direction.x,0,_direction.z);
	return vect

func GetPlayerOrientation()->Vector3:
	return _playerOrientation;
