extends CharacterBody2D


var spd = 40
var hp = 100
var flashing_t = -1.0

var follow = null


func _process(delta):

	if($PositionMarker.self_modulate.a > 0):
		$PositionMarker.self_modulate.a = lerp($PositionMarker.self_modulate.a, 0.0, 0.1)

	if follow == null:
		if get_tree().current_scene.get_node_or_null("%Player"):
			follow = get_tree().current_scene.get_node_or_null("%Player")

	if flashing_t > 0.0:
		$FlashingSpr.visible = true
	else:
		$FlashingSpr.visible = false

	flashing_t -= delta


func _physics_process(delta):
	if follow != null:
		velocity = lerp(velocity, global_position.direction_to(follow.global_position) * spd, 0.1)
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()


func hurt(kb_dir, damage):
	velocity = kb_dir * spd * 3

	hp -= damage

	flashing_t = 0.04

	spd *= 1.1

	if hp <= 0.0:
		queue_free()