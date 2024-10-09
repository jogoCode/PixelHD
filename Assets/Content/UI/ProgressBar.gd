extends UIProgressBar

@export var _ownerJaugeSys:JaugeSystem;
@export var _blancProgressVar:TextureProgressBar;

func _ready():
	set_max_value.connect(_set_max_value);
	if _owner == null:
		printerr("No owner ");
		return;

	if _ownerJaugeSys== null:
		printerr("No jauge system assign to the progressBar");
	
	if _blancProgressVar == null:
		printerr("No blanc progress bar");
	#_ownerJaugeSys = _owner.get_node("HealthSystem");
	
	#if _ownerJaugeSys == null:
			#printerr("No owner healthSystem");
			#_progressBar.max_value = _ownerJaugeSys._baseHp;
	_ownerJaugeSys.actualValueChanged.connect(_update_progressBar)
	_ownerJaugeSys.actualValueChanged.connect(_set_max_value);
	#_ownerJaugeSys.Heal.connect(_update_progressBar);

	if _progressBar == null:
		printerr("No progress bar ref");

func _update_progressBar():
	update_progressBar(_progressBar,_ownerJaugeSys._actualValue,6,0.5);
	await get_tree().create_timer(0.5).timeout;
	var tween2 = get_tree().create_tween();
	tween2.tween_property(_blancProgressVar,"value",_progressBar.value,0.5);

func _set_max_value():
	for node in get_children():
		if node is TextureProgressBar:
			node.max_value = _ownerJaugeSys._maxValue;
