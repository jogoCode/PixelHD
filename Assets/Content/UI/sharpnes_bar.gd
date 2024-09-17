extends UIProgressBar


@onready var _ownerWeapon:Weapon ;

func _ready() -> void:
	for node in _owner.get_children():
		if node is Weapon:
			_ownerWeapon = node;
	if _ownerWeapon == null:
		return
	_ownerWeapon.sharpnesChanged.connect(_update_progressBar);

	_update_progressBar();


func _update_progressBar():
	update_progressBar(_progressBar,_ownerWeapon._sharpness,1,0.5);
