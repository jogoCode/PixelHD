extends Node3D
class_name  MainCamera;

@export var _target:Node3D;
@export var _moveSpeed:float;
@export var _offset:Vector3 = Vector3(0,0,2);
@export var _oscillator:Oscillator;

func _ready():
	await get_tree().create_timer(1).timeout;
	for node in get_parent().get_children():
		if(node is PlayerCharacter):
			_target = node;

func _physics_process(delta):
	if(_target!=null):
		position = lerp(position,Vector3(_target.position.x+_offset.x,position.y+_offset.y,_target.position.z+_offset.z),_moveSpeed*delta);

func ShakeCamera(intensity,duration):
	for node in get_children():
		if(node.has_signal("Shake")):
			node.emit_signal("Shake",intensity,duration);
