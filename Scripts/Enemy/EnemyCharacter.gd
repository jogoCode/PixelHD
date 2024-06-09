extends Character
class_name  EnemyCharacter

@onready var _navAgent:NavigationAgent3D = $NavigationAgent3D;

@export var _target:Character;

var _atkRange:float = 10;

func _physics_process(delta):
	super._physics_process(delta);
	#MoveToTarget(delta);



func MoveToTarget(delta)->void:
	_navAgent.target_position = _target.global_position;	
	_direction = _navAgent.get_next_path_position() - global_position;
	_direction = _direction.normalized();	
	velocity = velocity.lerp(_direction*SPEED,5*delta);

func MoveToDirection(dir,delta)->void:
	if(!IsInImpulse()):
		velocity = dir*SPEED*delta;

func SetTarget(newTarget)->void:
	_target = newTarget;
