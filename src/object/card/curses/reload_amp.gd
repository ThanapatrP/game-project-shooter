# CURSE DESC:
# - Reload time by %
# - Ammo Capacity

class_name ReloadAmpCurse
extends Curse


@export var reload_reduction : float = 0.1
@export var ammo_cap_reduction : float = 0.05


func apply(player : Player):
	player.RELOAD_T *= (1.0 - reload_reduction)
	player.MAX_AMMO = clamp(floor((1.0 - ammo_cap_reduction) * player.MAX_AMMO), 1, INF)
	player.ammo = clamp(player.ammo, 0, player.MAX_AMMO)

	if Global.debug:
		print("UPGRADED")


