extends Area3D


func is_colliding()->bool:
	var areas = get_overlapping_bodies();
	return areas.size() > 0;
	

func get_push_vector():
	var areas:Array = get_overlapping_bodies();
	var pushVector:Vector3 = Vector3.ZERO;
	if is_colliding():
		var area = areas[0];
		pushVector = area.global_position.direction_to(global_position);
		pushVector = pushVector.normalized();
	return pushVector;
