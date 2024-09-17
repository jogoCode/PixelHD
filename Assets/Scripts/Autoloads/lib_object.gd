extends Node

var OBJECT:Dictionary;

func _ready() -> void:
	init();

func init():
	var Ressources = DirAccess.open("res://Assets/Ressources/Objects/");
	Ressources.list_dir_begin();
	var file_name = Ressources.get_next()
	while file_name != "":
		#if Ressources.current_is_dir():
			#print("Found directory: " + file_name)
		#else:
			#print("Found file: " + file_name)
		if '.tres.remap' in file_name: # <---- NEW
			file_name = file_name.trim_suffix('.remap') # <---- NEW
		OBJECT[file_name.get_basename()] = load("res://Assets/Ressources/Objects/"+file_name)
		file_name = Ressources.get_next()


func pick_random(): # il faut factoriser
	var objData:R_Object = OBJECT[OBJECT.keys().pick_random()];
	return objData;
