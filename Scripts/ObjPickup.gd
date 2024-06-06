extends Node3D

@export var _weapon:R_Weapon;
@onready var _sprite:Sprite3D = $Sprite3D;

func _ready():
	_sprite.texture = _weapon._img;


func _process(delta):
	pass


func _on_interact_system_interact(interacter):
	print(_weapon);
	for node in interacter.get_children():
		node.emit_signal("ChangeWeapon",_weapon);
	queue_free();	
