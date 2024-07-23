extends AnimationTree


@onready var isAtking = self["parameters/conditions/isAtk"];


func _ready():
	print(isAtking)


func _process(delta):	
	isAtking = self["parameters/conditions/isAtk"];
