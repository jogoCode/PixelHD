extends CharacterBody3D
class_name Character

@export var SPEED:float;
const JUMP_VELOCITY = 4.5

var _lastDir:Vector3;
var _direction:Vector3;
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var _stateMachine:StateAnimation = get_node("StateMachine");

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta;
	move_and_slide()
#----------SET GET--------------------------------------------------------------

func getLastDir() -> Vector3:
	return _lastDir;

func setDirection(newDir) -> void:
	_direction = (transform.basis * Vector3(newDir.x, 0, newDir.y)).normalized();

#---------SIGNAL----------------------------------------------------------------
