extends Node

var WEAPON:Dictionary;

func _ready() -> void:
	init();
	
func init():
	var Ressources = DirAccess.open("res://Assets/Ressources/Weapons/");
	Ressources.list_dir_begin();
	var file_name = Ressources.get_next()
	while file_name != "":
		if Ressources.current_is_dir():
			print("Found directory: " + file_name)
		else:
			print("Found file: " + file_name)
		if '.tres.remap' in file_name: # <---- NEW
			file_name = file_name.trim_suffix('.remap') # <---- NEW
		WEAPON[file_name.get_basename()] = load("res://Assets/Ressources/Weapons/"+file_name)
		file_name = Ressources.get_next()
	print(WEAPON,"LIB weapon:")


func pick_random():
	var weaponData:R_Weapon = WEAPON[WEAPON.keys().pick_random()];
	return weaponData;
