extends Node3D
class_name trigger

@export var _action:triggerAction
var _area:Area3D;

func _ready() -> void:
	if !_action:
		for action in get_children():
			if action is triggerAction:
				_action = action;
	for area in get_children():
		if area is Area3D:
			_area = area;
	_area.area_entered.connect(action);
	#if _area:
		#_area.area_shape_exited.connect(_action._on_area_3d_area_exited);

func action(area):
	if _action:
		_action.action(area);
