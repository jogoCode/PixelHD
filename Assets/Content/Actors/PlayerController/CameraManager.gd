extends Node3D
class_name  MainCamera;

@export var _target:Node3D;
@export var _moveSpeed:float;
@export var _offset:Vector3 = Vector3(0,0,2);
@export var _oscillator:Oscillator;

var _inZoom:bool = false;

func _ready():
	await get_tree().create_timer(1).timeout;
	for node in get_parent().get_children():
		if(node is PlayerCharacter):
			_target = node;

func _physics_process(delta):
	if(_target!=null):
		#var tween = get_tree().create_tween();
		#tween.set_trans(6);
		#tween.tween_property(self,"position",Vector3(_target.position.x+_offset.x,position.y+_offset.y,_target.position.z+_offset.z),0.1);
		if(_target._stateMachine.GetState() == "Roll" or 
			_target._stateMachine.GetState() == "Hit" or 
			_target._stateMachine.GetState() == "Atk01" or
			_target._stateMachine.GetState() == "Atk02" or
			_target._stateMachine.GetState() == "Atk03"):
				position = lerp(position,Vector3(_target.position.x+_offset.x,position.y+_offset.y,_target.position.z+_offset.z),_moveSpeed*10*delta);
		position = lerp(position,Vector3(_target.position.x+_offset.x,position.y+_offset.y,_target.position.z+_offset.z),_moveSpeed*delta);

func ShakeCamera(intensity,duration):
	for node in get_children():
		if(node.has_signal("Shake")):
			node.emit_signal("Shake",intensity,duration);


func ZoomCamera(intensity,duration):
	var tween:Tween = get_tree().create_tween();
	var lastFov:float = $Camera3D.fov;
	tween.set_trans(6);
	tween.tween_property($Camera3D,"fov",$Camera3D.fov+intensity,duration);
	await get_tree().create_timer(duration*2).timeout;
	_inZoom = true;	
	tween = get_tree().create_tween();
	tween.set_trans(1);
	tween.tween_property($Camera3D,"fov",75,duration);
	tween.finished.connect(reset_in_zoom);

func reset_in_zoom():
	_inZoom = false;
