extends Character
class_name  EnemyCharacter

@onready var _navAgent:NavigationAgent3D = $NavigationAgent3D;

@export var _target:Character;

var _atkRange:float = 2;

func _physics_process(delta):
	super._physics_process(delta);
	#MoveToTarget(delta);



func MoveToTarget(delta)->void:
	_navAgent.target_position = _target.global_position;	
	_direction = _navAgent.get_next_path_position() - global_position;
	_direction = _direction.normalized();	
	velocity = velocity.lerp(_direction*SPEED/4,SPEED/2*delta);

func MoveToDirection(dir,delta)->void:
	pass
	velocity = velocity.lerp(dir*SPEED/4,SPEED/2*delta);

func SetTarget(newTarget)->void:
	_target = newTarget;


func _on_detection_zone_area_entered(area):
	if(area.get_parent() is PlayerCharacter):
		SetTarget(area.get_parent())


func _on_health_system_take_damage(damage, damager):
	_stateMachine.SetState("Hit");
	_stateMachine.GetState();


func _on_state_machine_change_state(newState):
	pass # Replace with function body.
