extends Attack
class_name DistAtk

@export var _projectile:PackedScene;
@export var _origin:Marker3D;
@export var _cooldown:float = 0.1;
var _originVect:Vector3;
var _canShoot = true;

var test= 0;

func _ready():
	doAttack.connect(Atk);

func Atk():
	if !_origin:
		_originVect = _owner.global_position;
	else:
		_originVect = _origin.global_position;
	_owner._lastDir = _owner.GetTargetDirection();
	var projInstance = _projectile.instantiate();
	projInstance.global_position = _originVect;
	if projInstance is Projectile:
		projInstance._dir = _owner._visionRay.target_position.normalized();
		projInstance._owner = owner;
	if _canShoot:
		Level.main.add_child(projInstance);
		_canShoot = false;
		await get_tree().create_timer(_cooldown*1).timeout
		_canShoot = true;
