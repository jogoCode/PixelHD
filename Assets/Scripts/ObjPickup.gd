@tool
extends Node3D
class_name ObjPickup

@export var _weapon:R_Weapon;
@export var _sprite:Sprite3D;
@export var _StatDisplayer:Sprite3D;

signal DisplayStats();

func _ready():
	_sprite.texture = _weapon._img;

func _process(delta):
	_sprite.texture = _weapon._img;

func _input(event):
	_StatDisplayer.hide();

func _on_interact_system_interact(interacter):
	var interacterStateMachine = interacter._stateMachine;
	if interacterStateMachine.GetState() == "Idle" or interacterStateMachine.GetState() == "Walk":
		for node in interacter.get_children():
			if node.has_signal("ChangeWeapon"):
				node.emit_signal("ChangeWeapon",_weapon,position);
		queue_free();

func _on_display_stats():
	_StatDisplayer.show();
