# CURSE DESC:
# + Damage multiplier by %
# - MAX_HP by %

class_name DamageMultCurse
extends Curse

@export var add_dmg_mult : float = 0.1
@export var hp_reduction : float = 0.1


func apply(player : Player):
	player.bullet_dmg_mult += add_dmg_mult
	player.MAX_HP *= (1.0 - hp_reduction)
	if Global.debug:
		print("UPGRADED")
