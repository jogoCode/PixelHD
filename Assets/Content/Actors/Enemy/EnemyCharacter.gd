extends Character
class_name  EnemyCharacter

@onready var _navAgent:NavigationAgent3D = $NavigationAgent3D;

@export var _target:Character;
var _safeVel:Vector3;

var _ally:Array;
@export var _HitBox:CollisionShape3D;
@export var _HurtBox:CollisionShape3D;
@export var _atkRange:float = 2;
@export var _radiusToTarget:float = 0.5;
@export var _visionRay:RayCast3D;

@export var _atk:Attack;

var randnum:float;
var _canAtk:bool;

@export var _soundAtk:String;

@export var _mood:Moods;
@export var _canChangeMood:bool = true;

enum Moods{
	STRATEGIC,
	FIGHTER
}

func _ready():
	_HitBox.disabled = true;
	change_randnum();
	change_mood();

func _physics_process(delta):
	if _stateMachine.GetState() == "Die":
		$BeehaveTree.enabled = false;
		velocity = Vector3.ZERO;
		return;
	super._physics_process(delta);
	if(velocity.length()>1):
		_lastDir = Vector3(velocity.x,0,velocity.z).normalized();
	if (_stateMachine.GetState() == "Hit" or 
	_stateMachine.GetState() == "Atk" or
	_stateMachine.GetState() == "Pre_Atk"):
		if(_stateMachine.GetState() == "Hit"):
			#change the mood of the enemy when he is hit
			_mood = 1;
		velocity.x = 0;
		velocity.z = 0;
	$Label3D.text = str(_impulseVelocity)
	if _target:
		_visionRay.target_position = global_position.direction_to(_target.global_position).normalized()*_atkRange;

func change_mood():
	if _canChangeMood:
		_mood = randi_range(0,1);

func Atk():
	if _atk !=null:
		SoundFx.play(_soundAtk);
		_atk.doAttack.emit();

func change_randnum():
	var rng = RandomNumberGenerator.new();
	rng.randomize();
	randnum = rng.randf();

func MoveAwayToTarget(delta)->void:
	var negVel = -(global_position.direction_to(_target.global_position).normalized());
	velocity = negVel*SPEED*12*delta;
	#velocity = velocity.lerp(negVel*SPEED/6,SPEED/6*delta);

func get_circle_position(random):
	var kill_circle_center = _target.global_position;
	var radius = _radiusToTarget;
	var angle = random * PI * 2;
	var x = kill_circle_center.x + cos(angle) * radius;
	var y = kill_circle_center.z + sin(angle) * radius;
	return Vector2(x,y);

func MoveToTarget(delta)->void:
	_navAgent.target_position = Vector3(get_circle_position(randnum).x,_target.global_position.y,get_circle_position(randnum).y);
	_direction = _navAgent.get_next_path_position() - global_position;
	_direction = _direction.normalized();
	velocity = velocity.lerp(_direction*SPEED/6,SPEED/6*delta);
	

func MoveToDirection(dir,delta)->void:
	velocity = velocity.lerp(dir*SPEED/4,SPEED/2*delta);

func SetTarget(newTarget)->void:
	_target = newTarget;

func RayTouchTarget()->bool:
	if _visionRay.is_colliding() and _visionRay.get_collider().get_parent() == _target:
		return true;
	if _visionRay.is_colliding() and _visionRay.get_collider().get_parent() is EnemyCharacter:
		change_randnum();
		return false;
	return false;

func CheckAlly():
	var allyIsAtk:bool
	for ally in _ally:
		if ally != null:
			if ally._stateMachine.GetState()== "Pre_Atk":
				allyIsAtk = true;
				return;
			allyIsAtk = false;
	return allyIsAtk;

func GetTargetDirection()->Vector3:
	return _visionRay.target_position.normalized();

func StopMovement():
	velocity = Vector3.ZERO;
	await  get_tree().create_timer(1).timeout;

func _on_detection_zone_area_entered(area):
	if(area.get_parent() is PlayerCharacter):
		SetTarget(area.get_parent())
	if(area.get_parent() is EnemyCharacter):
		_ally.insert(0,area.get_parent());


func _on_health_system_take_damage(damage, damager):
	return;
	_stateMachine.SetState("Hit");

func _on_hit_box_area_entered(area): 
	if !(area.get_parent() is EnemyCharacter) and area.get_parent() is Character:
		if area.get_parent() != self.get_parent() and area.name == "HurtBox":
			for node in area.get_parent().get_children():
				if node.has_signal("TakeDamage"):
					node.emit_signal("TakeDamage",15,self);
					return;



func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	_safeVel = safe_velocity;
