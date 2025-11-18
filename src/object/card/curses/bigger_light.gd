# CURSE DESC:
# + light scope
# - ammo cap

class_name BiggerLightCurse
extends Curse

@export var ammo_decrease : float = 0.1
@export var light_scope_mult : float = 0.1

var player_curr_light_t = 0.0

func apply(player : Player):
	player.ACTIVE_LIGHT_SCALE = int(floor(player.ACTIVE_LIGHT_SCALE * (1.0 + light_scope_mult)))
	player.PLAYER_LIGHT_SCALE = int(floor(player.PLAYER_LIGHT_SCALE * (1.0 + light_scope_mult)))

	player.MAX_AMMO *= 1.0 - ammo_decrease
	player.ammo = clamp(player.ammo, 0, player.MAX_AMMO)

	if Global.debug:
		print("UPGRADED")

func update_info():
	if Global.player:
		player_curr_light_t = Global.player.DEF_LIGHT_POW

func get_desc() -> String:
	return "[color=green]Spotlight scope larger by {0}%[/color]\n[color=red]Decrease ammo capacity by {1}%".format([int(light_scope_mult * 100), int(ammo_decrease * 100)])