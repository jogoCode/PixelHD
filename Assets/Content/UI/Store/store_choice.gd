extends Button
class_name StoreChoice

var _actualType:ChoiceTypes

enum ChoiceTypes{
	WEAPON,
	OBJECT
}
@onready var _owner = get_parent();
@export var _weapon:R_Weapon;
@export var _object:R_Object;
@export var _price:int;
@onready var _priceLabel:Label = $PriceLabel;

var _action;

@onready var _statsDisplay = $StatsDisplay;

func _ready() -> void:
	$PriceLabel.text = str(_price);
	pressed.connect(_choose_weapon);

func update_price(price) -> void:
	if price > Level._soul:
		disabled = true;
	else:
		disabled = false;
	_price = price;
	_priceLabel.text = str(_price);

func update_statsDisplay(choiceType) -> void:
	_statsDisplay._actualType = choiceType;

func _choose_weapon() -> void:
	match _statsDisplay._actualType:
		ChoiceTypes.WEAPON:
			get_parent()._weapon_choosed();
			Level._PLAYER._weapon.ChangeWeapon.emit(_weapon,100,Vector3.DOWN);
		ChoiceTypes.OBJECT:
			get_parent()._weapon_choosed();
			var action = _action.new();
			action.action(_object._value)
	Level.removeSoul.emit(_price);
