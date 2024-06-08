extends Character
class_name  EnemyCharacter


func _physics_process(delta):
	super._physics_process(delta);
	velocity.x = 10*delta;
