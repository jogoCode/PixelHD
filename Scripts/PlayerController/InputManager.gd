extends Node

@export var _playerCharacter:PlayerCharacter;

var _inputsLib:Array;
@export var _bufferTimer:float = 0;
@export var _bufferTime:float = 0.15;


signal Interact;



func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	update_buffer_timer()
		# MOVE
	var inputDir = Input.get_vector("ui_left","ui_right","ui_up","ui_down");
	_playerCharacter.setDirection(inputDir.normalized());	
	if Input.is_action_pressed("ui_right") || Input.is_action_pressed("ui_left"):
		inputDir.y = 0
	elif Input.is_action_pressed("ui_up") || Input.is_action_pressed("ui_down"):
		inputDir.x = 0
	_playerCharacter._inputVector = Vector2(sign(inputDir.x),sign(-inputDir.y));
		# ATK
	if(Input.is_action_just_pressed("ui_accept")):
		add_to_inputs_lib("ui_accept");
		_playerCharacter.Atk();
		buffer_input()
		# DODGE
	if(Input.is_action_just_pressed("Dodge")):
		add_to_inputs_lib("Dodge");
		_playerCharacter.Roll();
		buffer_input()
		# INTERACT
	if(Input.is_action_just_pressed("Interact")):
		emit_signal("Interact");


func update_buffer_timer():
	_bufferTimer-=Level.DELTA;
	_bufferTimer = clamp(_bufferTimer,0,0.85);
	if _bufferTimer <= 0 and _inputsLib.size() > 0:
		var action =  _inputsLib.pop_front();
		process_input(action);

func buffer_input():
	_bufferTimer = _bufferTime;

func process_input(action):
	match action:
			"ui_accept":
					_playerCharacter.Atk();
					return;		
			"Dodge":
					_playerCharacter.Roll();
					return;

func add_to_inputs_lib(inputName:String):
	await get_tree().create_timer(_bufferTimer*2).timeout;
	_inputsLib.insert(0,inputName);
	if(_inputsLib.size()>4):
		_inputsLib.resize(4);

func clear_inputs_lib(id:int):
	await get_tree().create_timer(_bufferTimer).timeout;
	_inputsLib.insert(id,null);
	if(_inputsLib.size()>4):
		_inputsLib.resize(4);

func _get_configuration_warnings():
	var warnings = []

	if _playerCharacter == null:
		warnings.append("Please set PlayerCharacter to a non-empty value.")
	# Returning an empty array means "no warning".
	return warnings;
