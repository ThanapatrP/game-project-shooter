extends CharacterBody2D


var hp = 100
var flashing_t = 0.0


func _process(delta):
	flashing_t -= delta

	if flashing_t > 0.0:
		$FlashingSpr.visible = true
	else:
		$FlashingSpr.visible = false


func hurt(damage):
	hp -= damage

	flashing_t = 0.04

	if hp <= 0.0:
		queue_free()