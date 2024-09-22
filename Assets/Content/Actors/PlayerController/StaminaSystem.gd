extends Node
class_name StaminaSystem;

@export var _baseStamina:float = 100;
@export var _actualStamina:float =0;
@export var _maxStamina:float =100;

@export var _staminaRegen:float = 5;

var _staminaRegenTime:float = 1;
var _staminaRegenTimer:float;

var _canRegen:bool = false;

signal remove_stamina(value);
signal start_regen();

func _ready() -> void:
	remove_stamina.connect(_remove_actual_stamina);
	init();

func _process(delta: float) -> void:
	update_stamina_regen(delta);
	if Input.is_action_just_pressed("ui_accept"):
		remove_stamina.emit(5);


func init()->void:
	_actualStamina = _baseStamina;

func update_stamina_regen(delta)->void: #update the stamina regen
	print(_actualStamina," | time:",_staminaRegenTimer);
	if _actualStamina >= _maxStamina: # check if stamina is < maxstamine
		return;
	if _canRegen: # check if can regen
		_staminaRegenTimer-=delta;
		_staminaRegenTimer = clamp(_staminaRegenTimer,0,100);
		if _staminaRegenTimer <= 0.01:
			_add_actual_stamina(_staminaRegen)

func _add_actual_stamina(value)->void:
	_actualStamina += value;
	_actualStamina = clamp(_actualStamina,0,_maxStamina);
	if _actualStamina != _maxStamina:
		_launch_timer();

func _remove_actual_stamina(value)->void:
	_actualStamina -= value;
	_actualStamina = clamp(_actualStamina,0,_maxStamina);
	_canRegen = false;
	_start_regen();
	
func _start_regen():
	await get_tree().create_timer(2).timeout; #remove hard value;
	_canRegen = true;
	_launch_timer();

func _launch_timer()->void:
	_staminaRegenTimer = _staminaRegenTime;
