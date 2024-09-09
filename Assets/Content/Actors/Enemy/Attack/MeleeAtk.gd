extends Attack
class_name AtkMelee

@export var _dashDist:float = 800

func _ready():
	doAttack.connect(Atk);

func Atk():
	_owner._impulseVelocity = Vector3.ZERO
	if _owner._impulseVelocity == Vector3.ZERO:
		var dir = (_owner._target.position - _owner.global_position).normalized();
		_owner.applyImpulse(dir*_dashDist*Level.DELTA,5);
		_owner.change_randnum();
		return;
