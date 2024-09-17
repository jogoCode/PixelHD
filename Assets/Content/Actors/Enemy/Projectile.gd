extends Area3D
class_name Projectile

var _owner:Character;
@export var _SPEED:float = 5;
@export var _damage:float = 15;
@export var _dir:Vector3;
@export var _delayToDestroy:float = 5;
@export var _destroyAtTouch:bool = true;

func _ready():
	await get_tree().create_timer(_delayToDestroy).timeout;
	queue_free();

func _process(delta):
	translate(Vector3(_dir.x,0,_dir.z)*delta*_SPEED);
	


func _on_area_entered(area):	
	#if !(area.get_parent() is EnemyCharacter) and area.get_parent() is Character:
	if !(area.get_parent() is EnemyCharacter) and area.get_parent() is Character:
		print(area.get_parent().name)
		if area.get_parent() != self.get_parent() and area.name == "HurtBox":
			for node in area.get_parent().get_children():
				if node.has_signal("TakeDamage"):
					node.emit_signal("TakeDamage",_damage,_owner);
					if area.get_parent()._stateMachine.GetState() != "Roll":
						hide()
						await get_tree().create_timer(0.1).timeout;
						if _destroyAtTouch:
							queue_free();
					return; # Replace with function body.
