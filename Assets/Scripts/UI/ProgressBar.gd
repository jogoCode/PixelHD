extends Control
class_name UIProgressBar

@export var _owner:Character;
var _ownerHealthSys:HealthSystem;

@export var _progressBar:TextureProgressBar;

@export var _progressFactor:float = 5

func _ready():
	if _owner == null:
		printerr("No owner ");
		return;
	_ownerHealthSys = _owner.get_node("HealthSystem");
	
	if _ownerHealthSys == null:
			printerr("No owner healthSystem");
			_progressBar.max_value = _ownerHealthSys._baseHp;
	_ownerHealthSys.TakeDamage.connect(_update_progressBar)

	if _progressBar == null:
		return;
		printerr("No progress bar ref");




func _update_progressBar(damage,damager):
	var tween = get_tree().create_tween();
	tween.set_trans(6);
	tween.tween_property(_progressBar,"value",_ownerHealthSys._actualHp,0.5);
	await get_tree().create_timer(1).timeout;
	var tween2 = get_tree().create_tween();
	tween2.tween_property($DmgBar,"value",_progressBar.value,0.5);
