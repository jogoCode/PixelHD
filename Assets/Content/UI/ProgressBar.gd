extends UIProgressBar

var _ownerHealthSys:HealthSystem;

func _ready():
	if _owner == null:
		printerr("No owner ");
		return;
	_ownerHealthSys = _owner.get_node("HealthSystem");
	
	if _ownerHealthSys == null:
			printerr("No owner healthSystem");
			_progressBar.max_value = _ownerHealthSys._baseHp;
	_ownerHealthSys.hpChanged.connect(_update_progressBar)
	#_ownerHealthSys.Heal.connect(_update_progressBar)

	if _progressBar == null:
		printerr("No progress bar ref");

func _update_progressBar():
	update_progressBar(_progressBar,_ownerHealthSys._actualHp,6,0.5);
	await get_tree().create_timer(0.5).timeout;
	var tween2 = get_tree().create_tween();
	tween2.tween_property($DmgBar,"value",_progressBar.value,0.5);
