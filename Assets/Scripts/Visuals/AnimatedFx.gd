extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	rotate_z(randf_range(-180,180));


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_animated_sprite_3d_animation_finished():
	queue_free();
