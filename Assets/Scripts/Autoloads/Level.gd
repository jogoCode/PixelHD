extends Node


var _CAMERA:MainCamera;
var _PLAYER:PlayerCharacter;
var DELTA:float;
@onready var main = get_node("/root/Main");
var _dungeonSize:int = 11;

var _score:int;
var _hightScore:int;


var _inFreeze:bool = false;
signal GameFinished;
signal MonsterKill;

func _ready():
	MonsterKill.connect(_add_score);

func _process(delta):
	DELTA = delta;

func CreateObject(sceneToIntance:Node3D,pos:Vector3,rot:Vector3 = Vector3(0,0,1)):
	sceneToIntance.global_position = pos;
	main.add_child(sceneToIntance);
	if rot == Vector3(0,0,1):
		sceneToIntance.rotation_degrees = rot;
	else:
		sceneToIntance.look_at(sceneToIntance.position,Vector3.UP, true);

func CreateFx(fxToInstance:Node3D,pos:Vector3,rot:Vector3,amount:int = 1,scale:Vector3 = Vector3(1,1,1)):
	
	fxToInstance.global_position = pos;
	fxToInstance._amount = amount
	main.add_child(fxToInstance);
	fxToInstance.look_at(rot);


func AddCamera():
	var camPacked = preload("res://Assets/Prefabs/Camera.tscn");
	var camInstance = camPacked.instantiate();
	main.add_child(camInstance);

func FreezeFrame(timescale,duration):
	if !_inFreeze:
		Engine.time_scale = timescale;
		_inFreeze = true;
		await get_tree().create_timer(duration*timescale).timeout;
		Engine.time_scale = 1;
		_inFreeze = false;

func Init():
	main = get_node("/root/Main");
	if main!= null:
		for node in main.get_children():
			if(node is MainCamera):
				_CAMERA = node;
		for node in main.get_children():
			if(node is PlayerCharacter):
				_PLAYER = node;


func _add_score():
	_score+=1;