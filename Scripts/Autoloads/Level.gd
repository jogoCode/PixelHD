extends Node


var _CAMERA:MainCamera;
var DELTA:float;
@onready var main = get_node("/root/Main");

func _ready():
	for node in main.get_children():
		if(node is MainCamera):
			_CAMERA = node;

func _process(delta):
	DELTA = delta;

func CreateObject(sceneToIntance,pos:Vector3,rot:Vector3):
	sceneToIntance.global_position = pos;
	sceneToIntance.rotation_degrees = rot;
	add_child(sceneToIntance);

func AddCamera():
	var camPacked = preload("res://Prefabs/Camera.tscn");
	var camInstance = camPacked.instantiate();
	main.add_child(camInstance);

