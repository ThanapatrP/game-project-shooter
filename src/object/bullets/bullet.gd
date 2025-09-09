extends Area2D


const SPD = 600
var dir = Vector2.ZERO
var damage = 50


func _ready() -> void:
	connect("body_entered", hit)

func _process(delta):
	rotation = dir.angle()

func _physics_process(delta):
	global_position += dir * SPD * delta


func hit(body):
	if body is CharacterBody2D:
		body.hurt(dir, damage)
		queue_free()
