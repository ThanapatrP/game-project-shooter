class_name PttPlayer
extends CharacterBody2D


const SPD = 80.0
var p_input := Vector2.ZERO

const LIGHT_RAD := 16
const DEF_LIGHT_SCALE = 2.2
const PLAYER_LIGHT_SCALE = 1.7
var mouse_pos : Vector2 = Vector2.ZERO
var mouse_rad := 0.0
var mouse_dir : Vector2 = Vector2.ZERO


const DEF_SHOOT_CD = 0.1
var shoot_cd = 0.0


var bullet_res = preload("res://src/object/bullets/bullet.tscn")


func _ready():
	$LightPivot.top_level = true


func _process(delta):
	mouse_pos = round(get_global_mouse_position())
	mouse_dir = global_position.direction_to(get_global_mouse_position())

	var lerp_pow = 0.5

	# if get_global_mouse_position().distance_to(global_position) < 32:
	# 	$LightPivot.global_position = lerp($LightPivot.global_position, global_position, lerp_pow)
	# 	$LightPivot.scale = lerp($LightPivot.scale, Vector2(PLAYER_LIGHT_SCALE, PLAYER_LIGHT_SCALE), lerp_pow)
	# 	$LightPivot/PointLight2D.energy = lerp($LightPivot/PointLight2D.energy, 0.0, lerp_pow)

	# 	$SelfLight.energy = lerp($SelfLight.energy, 2.0, lerp_pow)
	# 	$SelfLight.scale = lerp($SelfLight.scale, Vector2(PLAYER_LIGHT_SCALE, PLAYER_LIGHT_SCALE), lerp_pow)

	# else:
	# 	$LightPivot.global_position = get_global_mouse_position()
	# 	$LightPivot.scale = lerp($LightPivot.scale, Vector2(DEF_LIGHT_SCALE, DEF_LIGHT_SCALE), lerp_pow)
	# 	$LightPivot/PointLight2D.energy = lerp($LightPivot/PointLight2D.energy, 2.0, lerp_pow)

	# 	$SelfLight.energy = lerp($SelfLight.energy, 1.5, lerp_pow)
	# 	$SelfLight.scale = lerp($SelfLight.scale, Vector2(PLAYER_LIGHT_SCALE * 0.4, PLAYER_LIGHT_SCALE * 0.4), lerp_pow)

	if Input.is_action_pressed("m2"):
		$LightPivot.global_position = lerp($LightPivot.global_position, get_global_mouse_position(), lerp_pow)
		$LightPivot.scale = lerp($LightPivot.scale, Vector2(DEF_LIGHT_SCALE, DEF_LIGHT_SCALE), lerp_pow)
	else:
		$LightPivot.global_position = lerp($LightPivot.global_position, global_position, lerp_pow)
		$LightPivot.scale = lerp($LightPivot.scale, Vector2(PLAYER_LIGHT_SCALE, PLAYER_LIGHT_SCALE), lerp_pow)

	shoot_cd -= delta

	p_input.x = Input.get_axis("left", "right")
	p_input.y = Input.get_axis("up", "down")

	p_input = p_input.normalized()

	if Input.is_action_pressed("m1"):
		shoot()


func _physics_process(delta):
	velocity = p_input * SPD

	move_and_slide()


func shoot():
	if shoot_cd > 0.0:
		return
	
	var bullet : Area2D = bullet_res.instantiate()
	bullet.global_position = global_position
	bullet.dir = mouse_dir

	get_tree().current_scene.add_child(bullet)

	shoot_cd = DEF_SHOOT_CD
