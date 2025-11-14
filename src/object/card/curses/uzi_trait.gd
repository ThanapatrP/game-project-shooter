# CURSE DESC:
# + firerate
# - accuracy

class_name UziTraitCurse
extends Curse

@export var firerate_mult : float = 0.02
@export var accuracy_decrease : float = 0.05


func apply(player : Player):
	player.DEF_SHOOT_CD *= 1.0 - firerate_mult
	player.bullet_spread *= 1.0 + accuracy_decrease

	if Global.debug:
		print("UPGRADED")
