# CURSE DESC:
# + light lifetime
# - light scope

class_name LongerLightCurse
extends Curse

@export var light_t_mult : float = 0.1
@export var light_scope_decrease : float = 0.05

var player_curr_light_t = 0.0

func apply(player : Player):
	player.ACTIVE_LIGHT_SCALE = int(floor(player.ACTIVE_LIGHT_SCALE * (1.0 - light_scope_decrease)))
	player.PLAYER_LIGHT_SCALE = int(floor(player.PLAYER_LIGHT_SCALE * (1.0 - light_scope_decrease)))
	player.DEF_LIGHT_POW *= 1.0 + light_t_mult

	if Global.debug:
		print("UPGRADED")

func update_info():
	if Global.player:
		player_curr_light_t = Global.player.DEF_LIGHT_POW

func get_desc() -> String:
	return "[color=green]Spotlight stay longer by {0}%({1}s)[/color]\n[color=red]Decrease accuracy by {2}%".format([int(light_t_mult * 100),"%.3f" % (float(player_curr_light_t) * light_t_mult), int(light_scope_decrease * 100)])
