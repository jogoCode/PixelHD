extends Control

@export var _offset:Vector2;
var _choice:int = 3;
var _storeChoice = load("res://Assets/Content/UI/Store/StoreChoice.tscn")
signal weaponChoosed()

func _ready() -> void:
	Level.OpenStore.connect(update_items);
	weaponChoosed.connect(_weapon_choosed);
	$ButtonQuit.pressed.connect(_hide)
	init()
	
func init():
	for i in range(_choice):
		var choiseInst:StoreChoice = _storeChoice.instantiate();
		#var weaponData:R_Weapon = LibWeapon.pick_random();
		#var previous = get_child(get_child_count()-1)
		#if previous != null and previous is StoreChoice:
			#while weaponData == get_child(get_child_count()-1)._weapon:
				#weaponData = LibWeapon.pick_random();
		choiseInst.global_position = position+_offset;
		choiseInst.position.x +=i*250;
		#choiseInst._weapon = weaponData;
		#choiseInst._price = weaponData._dmg*2;
		add_child(choiseInst);

func update_items():
	var previouses:Array;
	for node in get_children():
		var rand 
		rand = randi_range(0,1);
		print("WAVE",Level._wave)
		if Level._wave < 10:
			rand = 0;
		if(Level._PLAYER.GetHp() < 25):
			rand = randi_range(0,2);
		if node is StoreChoice:
			 #WEAPON
			if rand < 1:
				var weaponData:R_Weapon = LibWeapon.pick_random();
				for item in previouses:
					while item == weaponData or item == Level._PLAYER._weapon._weaponActualStats:
						weaponData= LibWeapon.pick_random();
						if item != weaponData:
							return

				node._weapon = weaponData;
				print(node._weapon,"WEAPON");
				node.update_price(node._weapon._price);
				node.update_statsDisplay(0);
				
				previouses.insert(0,weaponData)
				
			#OBJECT
			else: 
				var objectData:R_Object = LibObject.pick_random();
				for item in previouses:
					while item == objectData:
						objectData = LibObject.pick_random();
						if item != objectData:
							update_items();
							return;
				node._object = objectData;
				node._action = objectData._bonus;
				node._statsDisplay._actualType = 1;
				node.update_price(node._object._price);	
				node.update_statsDisplay(1);
		print(previouses)
	_show();	
	#previouses.clear();

func _show():
	$AnimationPlayer.play("show");
	await get_tree().create_timer(1).timeout;
	for node in get_children():
		if node is StoreChoice:
			node.grab_focus();
			return;


func _hide():
	for node in get_children():
		if node is StoreChoice:
			node.release_focus();
	$AnimationPlayer.play("hide");

func call_pause():
	GameManager.isPaused.emit();

func call_an_pause():
	GameManager.isAnPaused.emit();

func _weapon_choosed():
	_hide();
	return;
	await get_tree().create_timer(0.25).timeout
	for node in get_children():
		if node is Control:
			node.queue_free();
