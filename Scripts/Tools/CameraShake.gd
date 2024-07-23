extends Node;
class_name CameraShaker;

@export var _camera:MainCamera;

var _shakeIntensity:float = 0.0;
var _shakeDuration:float = 0.0;
var originalTransform:Transform3D;

signal Shake(intensity,duration);

# Appelée à chaque frame, avec delta étant le temps écoulé depuis la dernière frame
func _process(delta):
	if _shakeDuration > 0:
		_shakeDuration -= delta
		var shake_offset = Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1)) * _shakeIntensity
		_camera.global_transform.origin = lerp(_camera.global_transform.origin,originalTransform.origin + shake_offset,delta*50);
		if _shakeDuration <= 0:
			_camera.global_transform.origin = lerp(_camera.global_transform.origin,originalTransform.origin,delta);

# Fonction pour commencer la vibration de la caméra
func startShake(intensity, duration):
	_shakeIntensity = intensity;
	_shakeIntensity = clamp(_shakeIntensity,0,0.15);
	_shakeDuration = duration
	originalTransform =  _camera.global_transform;


func _on_shake(intensity,duration):
	startShake(intensity,duration);
