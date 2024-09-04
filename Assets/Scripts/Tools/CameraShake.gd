extends Node;
class_name CameraShaker;

@export var _camera:Node3D;

var _shakeIntensity:float = 0.0;
var _shakeDuration:float = 0.0;
var originalTransform:Transform3D;

signal Shake(intensity,duration);

# Appelée à chaque frame, avec delta étant le temps écoulé depuis la dernière frame
func _process(delta):
	if _shakeDuration > 0:
		_shakeDuration -= delta
	
	#if _shakeDuration > 0:
		#_shakeDuration -= delta
		#var shake_offset = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)) * _shakeIntensity
		#_camera.global_transform.origin = lerp(_camera.global_transform.origin,originalTransform.origin + shake_offset,delta*25);
		#if _shakeDuration <= 0:
			#_camera.global_transform.origin = lerp(_camera.global_transform.origin,originalTransform.origin,delta);

# Fonction pour commencer la vibration de la caméra
func startShake(intensity, duration):	
	_camera._oscillator.add_velocity.emit(Oscillator.Modes.POSITION,intensity);


func _on_shake(intensity,duration):
	startShake(intensity,duration);
