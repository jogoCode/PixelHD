extends RigidBody3D

var time = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	apply_central_impulse(Vector3.UP*4);
	await  get_tree().create_timer(0.1).timeout;
	var tween = get_tree().create_tween();
	#tween.set_trans(6);
	#tween.tween_property(self,"position",Level._PLAYER.global_position,1);
	await  get_tree().create_timer(0.5).timeout;
	axis_lock_linear_y = true;
	$CollisionShape3D.disabled = true;
	$Area3D/AreaCollisionShape3D.disabled = false;

func _physics_process(delta: float) -> void:
	time+=delta*5;
	var playerPos = Level._PLAYER.global_position;
	if axis_lock_linear_y:
		position = lerp(position,Vector3(playerPos.x,playerPos.y+0.1,playerPos.z),delta*time)

func _on_area_3d_area_entered(area: Area3D) -> void:
	print(area.get_parent().name);
	if area.get_parent() is PlayerCharacter:
		#$GPUParticles3D.emitting = false;
		Level.addSoul.emit();
		await  get_tree().create_timer(0.2).timeout;
		queue_free();
