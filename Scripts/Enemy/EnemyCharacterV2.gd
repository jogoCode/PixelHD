extends Character
class_name  EnemyCharacter

@onready var _navAgent:NavigationAgent3D = $NavigationAgent3D;

@export var _target:Character;


@export var _HitBox:CollisionShape3D;
var _atkRange:float = 2;

func _physics_process(delta):
	super._physics_process(delta);
	if(velocity.length()!=0):
		_lastDir = velocity.normalized();
	#MoveToTarget(delta);



func MoveToTarget(delta)->void:
	_navAgent.target_position = _target.global_position;	
	_direction = _navAgent.get_next_path_position() - global_position;
	_direction = _direction.normalized();	
	velocity = velocity.lerp(_direction*SPEED/6,SPEED/6*delta);

func MoveToDirection(dir,delta)->void:
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


func _on_hit_box_area_entered(area): 
	if !(area.get_parent() is EnemyCharacter) and area.get_parent() is Character:
		if area.get_parent() != self.get_parent():
			for node in area.get_parent().get_children():
				if node.has_signal("TakeDamage"):
					node.emit_signal("TakeDamage",5,self);
		await get_tree().create_timer(0.1).timeout;
