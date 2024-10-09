extends Control

@export var _offset:Vector2;
var _choice:int = 3;
var _storeChoice = load("res://Assets/Content/UI/Store/StoreChoice.tscn");
@onready var _arrayObjects = LibObject.OBJECT.values();
@onready var _arrayWeapons = LibWeapon.WEAPON.values();
signal weaponChoosed()

func _ready() -> void:
	print(pick_random_in_items_lib(1)._name);
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
	_arrayObjects = LibObject.OBJECT.values();
	_arrayWeapons = LibWeapon.WEAPON.values();
	for node in get_children():
		var rand 
		rand = randi_range(0,2);
		if(Level._PLAYER.GetHp() < 25):
			rand = randi_range(0,3);
		if node is StoreChoice:
			 #WEAPON
			if rand < 1:
				var weaponData:R_Weapon = pick_random_in_items_lib(0);
				node._weapon = weaponData;
				node.update_price(node._weapon._price);
				node.update_statsDisplay(0);
				
			#OBJECT
			else: 
				var objectData:R_Object = pick_random_in_items_lib(1);
				node._object = objectData;
				node._action = objectData._bonus;
				node._statsDisplay._actualType = 1;
				node.update_price(node._object._price);	
				node.update_statsDisplay(1);
	_show();	

func pick_random_in_items_lib(ItemType:int):
	var _selectedItem
	match ItemType:
		0:
			var randNum = randi() % _arrayWeapons.size();
			_selectedItem = _arrayWeapons[randNum];
			_arrayWeapons.remove_at(randNum);
		1:
			var randNum = randi() % _arrayObjects.size();
			_selectedItem = _arrayObjects[randNum];
			_arrayObjects.remove_at(randNum);
	print("JOjo",_selectedItem);
	return _selectedItem;

func _show():
	$AnimationPlayer.play("show");
	await get_tree().create_timer(2).timeout;
	for node in get_children(): 
		if node is StoreChoice:
			node.grab_focus();
			return;


func _hide():
	for node in get_children(): # disable all buttons
		if node is StoreChoice:
			node.release_focus();
			node.disabled = true;
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
