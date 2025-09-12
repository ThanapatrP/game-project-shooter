extends Node

var spawn_cd = [1.5,3]
var spawn_count = [2,5]

var enemy_scene = preload("res://src/characters/enemy/running_enemy.tscn")

var timer : Timer = null

func _ready() -> void:
	randomize()

	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", spawn_rand)
	timer.autostart = false
	timer.one_shot = true

	timer.start(randf_range(spawn_cd.get(0), spawn_cd.get(1)))

func spawn_rand():
	randomize()
	var new_range = randf_range(spawn_count.get(0), spawn_count.get(1))
	for i in range(0, new_range):
		spawn()

	timer.start(randf_range(spawn_cd.get(0), spawn_cd.get(1)))


func spawn():
	randomize()

	var new_ene = enemy_scene.instantiate() as Node2D

	new_ene.global_position = Vector2(randf_range(-32, 320+32), randf_range(-32, 180+32))
	
	get_tree().current_scene.add_child(new_ene)
