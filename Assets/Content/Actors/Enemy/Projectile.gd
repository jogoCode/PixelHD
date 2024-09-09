extends Node3D
class_name Projectile

var _owner:Character;
@export var _SPEED:float = 5;
@export var _damage:float = 15;
var _dir:Vector3;

func _ready():
	await get_tree().create_timer(5).timeout;
	queue_free();

func _process(delta):
	translate(Vector3(_dir.x,0,_dir.z)*delta*_SPEED);
	


func _on_area_entered(area):	
	if !(area.get_parent() is EnemyCharacter) and area.get_parent() is Character:
		if area.get_parent() != self.get_parent() and area.name == "HurtBox":
			for node in area.get_parent().get_children():
				if node.has_signal("TakeDamage"):
					node.emit_signal("TakeDamage",_damage,_owner);
					if area.get_parent()._stateMachine.GetState() != "Roll":
						hide()
						await get_tree().create_timer(1).timeout;
						queue_free();
					return; # Replace with function body.
