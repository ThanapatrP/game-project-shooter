# CURSE DESC:
# + MAXHP (& current HP)
# - invin time

class_name InvinTradeCurse
extends Curse

@export var hp_mult : float = 0.1
@export var invin_decrese : float = 0.2


func apply(player : Player):
	var curr_player_hp_ratio = float(player.hp) / float(player.MAX_HP)

	player.MAX_HP *= 1.0 + hp_mult
	player.hp = player.MAX_HP * curr_player_hp_ratio

	player.invin = clamp(player.invin * (1.0 - invin_decrese), 0.1, INF)

	Global.set_hp_progress(player.hp / player.MAX_HP)

	if Global.debug:
		print("UPGRADED")

func get_desc() -> String:
	return "[color=green]Decrease max HP (& current HP) by {0}%[/color]\n[color=red]Decrease invincible time by {1}%".format([int(hp_mult * 100), int(invin_decrese * 100)])