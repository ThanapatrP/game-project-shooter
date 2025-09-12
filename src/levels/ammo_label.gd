extends Label

func _process(delta: float) -> void:
	var plr = get_node_or_null("%Player")
	if plr != null:
		if plr.reload_cd > 0.0:
			text = "Reloading..."
		else:
			text = var_to_str(plr.ammo) + "/30"