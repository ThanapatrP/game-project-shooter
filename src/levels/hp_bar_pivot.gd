extends Node2D

func _process(delta: float) -> void:
	var plr = get_node_or_null("%Player")
	if plr != null:
		scale.x = clamp(plr.hp / 100, 0, 1)