extends RayCast3D

@onready var _owner:Character = get_parent();
var _canActive;

func _ready():
	pass

func _process(delta):
	if(is_colliding()):
		if(get_collider() != null):
			get_collider().get_parent().emit_signal("DisplayStats");
		if(_canActive):
			_canActive = false;
			for node in get_collider().get_parent().get_children():
				node.emit_signal("Interact",_owner);
	
	WeaponOrientation();


func WeaponOrientation()->void:
	match _owner.GetPlayerOrientation():
		Vector3(1,0,0): #Right
			rotation_degrees = Vector3(0,0,0);
		Vector3(-1,0,0): #Left
			rotation_degrees = Vector3(0,-180,0);
		Vector3(0,0,-1): #Down
			rotation_degrees = Vector3(0,-90,0);
		Vector3(0,0,1): #Up
			rotation_degrees = Vector3(0,90,0);
		#----------------DIAG--------------------------
		Vector3(1,0,1): #DiagUpRight
			rotation_degrees = Vector3(0,90,0);
		Vector3(-1,0,1): #DiagDownLeft
			rotation_degrees = Vector3(0,90,0);
		Vector3(-1,0,-1): #DiagUpLeft
			rotation_degrees = Vector3(0,-90,0);
		Vector3(1,0,-1): #DiagDownRight
			rotation_degrees = Vector3(0,-90,0);	


func _on_input_manager_interact():
	_canActive = true;
	await get_tree().create_timer(0.1).timeout;
	_canActive = false;
