extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func CreateObject(sceneToIntance,pos:Vector3,rot:Vector3):
	sceneToIntance.global_position = pos;
	sceneToIntance.rotation_degrees = rot;
	add_child(sceneToIntance);
