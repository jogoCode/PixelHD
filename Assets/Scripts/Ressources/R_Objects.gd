extends Resource;
class_name R_Object;

@export var _name:String;
@export var _type:Type = 0;
@export_enum("INCREASE","DECREASE") var _bonusType = 0;
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
	match _bonusType:
		0:
			var desc = _desc;
			_desc = ""
			_desc = desc+"\n +"+str(_value)+" "+_sufix;
		1:
			_desc+="\n -"+str(_value)+" "+_sufix;

enum Type{
	CONSOMABLE,
	ITEM
}
