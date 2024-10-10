
extends Sprite3D


@export var _sprites:Array[Texture2D];


func _process(delta: float) -> void:
	match GameManager._inputType:
		GameManager.InputTypes.GAMEPAD:
			texture = _sprites[1];
		GameManager.InputTypes.KEYBOARD:
			texture = _sprites[0];
