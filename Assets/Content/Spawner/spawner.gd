extends Node3D

@export var _enemiesLib:Array[PackedScene];


@onready var _spawnPointsLib:Array = get_children();
var _lastSpawnPoint = 0;

var _spawnFx= preload("res://Assets/Content/FX/spawn_fx.tscn")

var _isRestarting:bool = false;
var _wave:int;
@export var _delayToStart:float = 2;
@export var _enemyForWave:int = 4; 
@export var _delayBetweenSpawn:bool = true;
var _enemySpawn:int;

@export var _isActive:bool;

@export var _spawnParticle:bool;

@export var _messageLabel:Label;
@export var _waveNumLabel:Label;


func _ready():
	if _isActive:
		new_wave();
	Level.MonsterKill.connect(can_start_new_wave);
	

func new_wave():
	_spawnPointsLib.shuffle();
	if _messageLabel: # DEGEULASSE FAUT CHANGER
		_messageLabel.text = "NEW WAVE COMING..."
	await  get_tree().create_timer(_delayToStart).timeout;
	_wave+=1;
	if _messageLabel: # DEGEULASSE FAUT CHANGER
		_waveNumLabel.text = "WAVE "+str(_wave);
	_enemySpawn = 0;
	if _wave % 3:
		_enemyForWave +=1;
	spawn();
	_isRestarting = false;

func spawn():
	if _delayBetweenSpawn:
		await  get_tree().create_timer(_delayToStart/2).timeout;
	if _messageLabel:
		_messageLabel.text = "";
	if GameManager._actualState !=0:
		spawn();
		return;
	var enemieToSpawn
	#LIMITE LES ENEMIES A SPAWN
		#Progressions du spawn des différent enemies 
	if _wave <3: # progression
		enemieToSpawn = _enemiesLib[0];
	elif _wave <10: # progression
		enemieToSpawn = _enemiesLib[randi_range(0,1)]; 
	else: # progression
		enemieToSpawn = _enemiesLib.pick_random(); 

	var enemieInstance = enemieToSpawn.instantiate();
	if !_spawnPointsLib.is_empty():
		if _lastSpawnPoint >= _spawnPointsLib.size():
			_lastSpawnPoint = 0
		var spawnPoint = _spawnPointsLib[_lastSpawnPoint];
		enemieInstance.position = spawnPoint.global_position;	
		_lastSpawnPoint += 1;
		if _spawnParticle:
			Level.CreateObject(_spawnFx.instantiate(),spawnPoint.global_position);
	await  get_tree().create_timer(0.1).timeout;
	owner.add_child(enemieInstance);
	if _wave < 6: # progression
		for node in enemieInstance.get_children():
			if node.has_signal("Heal"):
				node._actualHp = node._actualHp/2;
	enemieInstance.add_to_group("enemies");
	_enemySpawn+= 1;
	if _enemySpawn % _enemyForWave:
		spawn();


func can_start_new_wave():
		await  get_tree().create_timer(_delayToStart).timeout;
		if Level.wave_is_finished():
			if _isRestarting == false:
				_isRestarting = true;
				new_wave();
				Level.set_wave_num(_wave);
