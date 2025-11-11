class_name Enemy
extends CharacterBody2D

var spd = 40
var hp = 100

var follow = null

var dead_point = 100

var kb_mult = 3
var apply_knockback = true

func apply_vel(to_glob_pos : Vector2):
	velocity = lerp(velocity, global_position.direction_to(to_glob_pos) * spd, 0.1)

func hurt(kb_dir : Vector2, damage : float, auto_free : bool = true):
	if apply_knockback:
		velocity = kb_dir * spd * kb_mult

	hp -= damage

	if hp <= 0.0: # DEAD
		on_dead(auto_free)

func on_dead(auto_free : bool):
	FxSpawner.spawn_float_text("[shake rate=40.0 level=20 connected=0]DEAD!", global_position + Vector2(0, -32), Color.RED, 1)
	FxSpawner.spawn_float_text("+%d" % dead_point, global_position + Vector2(0, -16), Color.WHITE, 2)

	EventCenter.emit_signal("enemy_dead", self)
	Global.add_score(dead_point)

	if auto_free:
		queue_free()
