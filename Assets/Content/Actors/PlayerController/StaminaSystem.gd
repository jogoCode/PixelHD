extends JaugeSystem
class_name StaminaSystem;

@export var _baseStamina:float = 100;
@export var _actualStamina:float =0;
@export var _maxStamina:float =100;

@export var _staminaRegen:float = 5;

@export var _staminaRegenTime:float = 1;
var _staminaRegenTimer:float;

var _canRegen:bool = false;

@export var _startRegenTime:float = 2;
var _timer:Timer;

signal remove_stamina(value);
signal start_regen();

func _ready() -> void:
	remove_stamina.connect(_remove_actual_stamina);
	init();

func _process(delta: float) -> void:
	update_stamina_regen(delta);



func init()->void:
	_baseValue = _baseStamina;
	_actualStamina = _baseStamina;
	_actualValue =_actualStamina;
	_maxValue = _maxStamina;
	# timer
	_timer = Timer.new();
	add_child(_timer);
	_timer.timeout.connect(_start_regen);
	


func update_stamina_regen(delta)->void: #update the stamina regen
	#print("stamina :",_actualStamina);
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
	_actualValue =_actualStamina;
	actualValueChanged.emit();
	if _actualStamina != _maxStamina:
		_launch_regen_timer();

func _remove_actual_stamina(value)->void:
	_actualStamina -= value;
	_actualValue =_actualStamina;
	_actualStamina = clamp(_actualStamina,0,_maxStamina);
	_canRegen = false;
	actualValueChanged.emit();
	_timer.start(_startRegenTime);

func _start_regen():
	#await get_tree().create_timer(2).timeout; #remove hard value;
	_canRegen = true;
	_launch_regen_timer();


func _can_use_stamina(minStamina:float = 0)->bool:
	var neededStamina:float = _actualStamina - minStamina;
	if _actualStamina > minStamina:
		return true;
	return false;

func _launch_regen_timer()->void:
	_staminaRegenTimer = _staminaRegenTime;
