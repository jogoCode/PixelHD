extends Resource;
class_name R_Weapon;

@export var _name:String;
@export var _type:Type;
@export var _img:CompressedTexture2D;
@export var _dmg:int;
@export var _atkSpeed:float;
@export var _desc:String;
@export var _hitboxSize:float;
@export var _fxColor:Color;
@export var _audio:String;

enum Type{
	LIGHT,
	HEAVY
}
