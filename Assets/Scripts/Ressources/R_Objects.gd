extends Resource;
class_name R_Object;

@export var _name:String;
@export var _type:Type;
@export var _img:CompressedTexture2D;
@export var _value:float;
@export var _bonus:Script;
@export var _desc:String;
@export var _fxColor:Color;
@export var _sufix:String;
@export var _price:int;
@export var _audio:String;

func init():
	if _bonus != null:
		pass

enum Type{
	CONSOMABLE,
	ITEM
}
