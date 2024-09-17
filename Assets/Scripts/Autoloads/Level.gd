extends Node


var _CAMERA:MainCamera;
var _PLAYER:PlayerCharacter;
var DELTA:float;
@onready var main = get_node("/root/Main");
var _dungeonSize:int = 11;

var _wave:int
var _score:int;
var _hightScore:int;
var _soul:int;

var _inFreeze:bool = false;
signal GameFinished;
signal MonsterKill;
signal OpenStore();
signal addSoul();
signal removeSoul(value);

func _ready():
	MonsterKill.connect(_add_score);
	addSoul.connect(_add_soul);
	removeSoul.connect(_remove_soul);

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
	Engine.time_scale = timescale;
	_inFreeze = true;
	await get_tree().create_timer(duration*timescale).timeout;
	Engine.time_scale = 1;
	_inFreeze = false;

func Init():
	main = get_node("/root/Main");
	GameManager._lastScene = main._actualType;
	_score = 0
	_soul = 0;
	var SaveData = load_score();
	_hightScore = SaveData.get("score");
	if main!= null:
		for node in main.get_children():
			if(node is MainCamera):
				_CAMERA = node;
		for node in main.get_children():
			if(node is PlayerCharacter):
				_PLAYER = node;

func _add_score():
	_score+=1;

func _add_soul():
	_soul+=2;

func _remove_soul(value):
	_soul-=value;
	main.UpdateSoul();

func wave_is_finished()->bool:
	return get_tree().get_nodes_in_group("enemies").is_empty();

func set_wave_num(wave):
	_wave = wave;
	if _wave%2 == 1:
		OpenStore.emit();
		print("SHOP")

func save_score()->void:
	if _score > _hightScore:
		_hightScore = _score
	var save_data = FileAccess.open("user://save_game.dat", FileAccess.WRITE);
	var save_dict = {
		"tutoDone" = GameManager._tutoDone,
		"score" = _hightScore
		}
	save_data.store_string(str(save_dict));

func load_score()->Dictionary:
	var file = FileAccess.open("user://save_game.dat", FileAccess.READ)
	var contentStr = file.get_as_text();
	var content = JSON.parse_string(contentStr);
	return content
