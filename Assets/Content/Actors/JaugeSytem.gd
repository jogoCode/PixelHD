extends Node
class_name JaugeSystem;

var _baseValue:float;
var _actualValue:float;
var _maxValue:float;

signal actualValueChanged();
signal maxValueChange();

func _ready() -> void:
	pass;

func GetBaseValue()->float:
	return _baseValue;
	
func GetActualValue()->float:
	return _baseValue;
	
func GetMaxValue()->float:
	return _baseValue;
