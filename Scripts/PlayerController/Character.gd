extends CharacterBody3D
class_name Character

@export var SPEED:float;
const JUMP_VELOCITY = 4.5

var _lastDir:Vector3;
var _direction:Vector3;
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var _impulseVelocity = Vector3.ZERO;
var _impulseFriction = 15.0;
var _isImpulsing:bool

var max_knockback_speed:float = 5;

@onready var _stateMachine:StateAnimation = get_node("StateMachine");

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta;
	impulse(delta);
	move_and_slide();

#---------MY LOGIC--------------------------------------------------------------
func impulse(delta):
	
	if _impulseVelocity.length() > 0:
		velocity.x = _impulseVelocity.x;
		velocity.z = _impulseVelocity.z;
		_impulseVelocity = _impulseVelocity.lerp(Vector3.ZERO, _impulseFriction*delta);
		if(_impulseVelocity.length() <= 0.001):
			_impulseVelocity = Vector3.ZERO

	if(self is PlayerCharacter):
		print(_impulseVelocity.length())

func applyImpulse(force: Vector3):
	_impulseVelocity += force;
		#if _impulseVelocity.length() >= max_knockback_speed:
			#_impulseVelocity = _impulseVelocity.normalized() * max_knockback_speed;

#----------SET GET--------------------------------------------------------------
func getLastDir() -> Vector3:
	return _lastDir;

func setDirection(newDir) -> void:
	_direction = (transform.basis * Vector3(newDir.x, 0, newDir.y)).normalized();

func IsInImpulse()->bool:
	return _isImpulsing;

#---------SIGNAL----------------------------------------------------------------

