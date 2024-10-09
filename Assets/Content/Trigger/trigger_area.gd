extends triggerAction;
class_name triggerActionLabel;


@export var _mode:Modes = Modes.PLAYER;
@onready var _owner:trigger = get_parent();

enum Modes{
	PLAYER,
	WEAPON
}

@export var _target:Node3D;

func action(area):
	_owner._area.area_exited.connect(_on_area_3d_area_exited);
	match _mode:
		Modes.PLAYER:
			_target.show();
		Modes.WEAPON:
			if area.get_parent() is Weapon:
				await  get_tree().create_timer(0.2).timeout;
				_target.show();

func _on_area_3d_area_exited(area: Area3D) -> void:
	if (area.get_parent() is PlayerCharacter):
		if _target:
			_target.hide();
