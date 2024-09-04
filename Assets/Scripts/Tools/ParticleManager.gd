extends Node3D
class_name ParticleManager;

var _amount:int;
@export var _destroyAtEnd:bool;

@export var _mainParticle:GPUParticles3D;
@export var _particles:Array[GPUParticles3D];

func _ready():
	_mainParticle.finished.connect(_destroy_at_end);
	for particle in _particles:
		particle.amount = _amount;
		particle.emitting = true;
	
	if _amount < 5:
		$ImpactBlood.hide();
		return
	var rand = randi_range(0,1);
	if rand == 0:
		SoundFx.play("BloodDrop",0.05)	
func _process(delta):
	pass
	
func _destroy_at_end():
	queue_free();
