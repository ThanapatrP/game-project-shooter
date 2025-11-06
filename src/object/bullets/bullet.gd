extends Area2D


const SPD = 900
var dir = Vector2.ZERO
var damage = 30


func _ready() -> void:
	rotation = dir.angle()
	connect("body_entered", hit)
	PauseParasite.create(self)

func _process(delta):
	rotation = dir.angle()

	if global_position.x > 600 or global_position.x < -50 or global_position.y > 440 or global_position.y < -50:
		queue_free()

func _physics_process(delta):
	global_position += dir * SPD * delta


func hit(body):

	var b = get_overlapping_bodies()[0]

	global_position = b.global_position

	b.hurt(dir, damage)

	queue_free()
