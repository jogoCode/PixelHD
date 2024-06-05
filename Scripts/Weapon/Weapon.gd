extends Node3D

@export var _owner:Character;

func _ready():
	hide();
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var inputVector = Input.get_vector("ui_left","ui_right","ui_down","ui_up");
	var direction = Vector3(inputVector.x,0,inputVector.y);
	print(direction);
	if(_owner._stateMachine.GetState() == "Atk"):
		show();
	else:
		hide();
	match direction:
		Vector3(1,0,0): #Right
			rotation_degrees = Vector3(0,0,0);
		Vector3(-1,0,0): #Left
			rotation_degrees = Vector3(0,-180,0);
		Vector3(0,0,-1): #Down
			rotation_degrees = Vector3(0,-90,0);
		Vector3(0,0,1): #Up
			rotation_degrees = Vector3(0,90,0);		
