extends Area2D


func _on_suck_timer_timeout() -> void:
	var enemies = get_overlapping_bodies()
	for enemy in enemies:
		enemy.hit_by_vacuum()
