extends Node3D



@export var _particle:GPUParticles3D;

@export var _amount:int;
@export var _process_material:ParticleProcessMaterial;
@export var _oneShot:bool
@export var _destroyAtEnd:bool

func _ready():
	if(_destroyAtEnd):
		_particle.finished.connect(destroy);
	if(_amount):
		_particle.amount = _amount
	_particle.one_shot = _oneShot;
	if(_process_material):
		_particle.process_material = _process_material;

func destroy():
	queue_free()
