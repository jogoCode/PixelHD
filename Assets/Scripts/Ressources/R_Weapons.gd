extends Resource;
class_name R_Weapon;

@export var _name:String;
@export var _type:Type;
@export var _img:CompressedTexture2D;
@export var _dmg:int;
@export var _atkSpeed:float;
@export var _atkSpe:AtkSpecials = AtkSpecials.SPIN;
@export var _desc:String;
@export var _price:int;
@export var _hitboxSize:float;
@export var _fxColor:Color;
@export var _shaded:bool = true;
@export var _audio:String;
@export var _projo:PackedScene;
enum Type{
	LIGHT,
	HEAVY
}

enum AtkSpecials{
	SPIN,
	PROJO
}
