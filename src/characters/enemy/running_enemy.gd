extends CharacterBody2D


const SPD = 20
var hp = 100
var flashing_t = 0.0

var follow = null


func _process(delta):
	if follow == null:
		if get_tree().current_scene.get_node_or_null("%Player"):
			follow = get_tree().current_scene.get_node_or_null("%Player")

	flashing_t -= delta

	if flashing_t > 0.0:
		$FlashingSpr.visible = true
	else:
		$FlashingSpr.visible = false


func _physics_process(delta):
	if follow != null:
		velocity = global_position.direction_to(follow.global_position) * SPD
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()


func hurt(damage):
	hp -= damage

	flashing_t = 0.04

	if hp <= 0.0:
		queue_free()