class_name PttPlayer
extends CharacterBody2D


const SPD = 80.0
var p_input := Vector2.ZERO


const LIGHT_RES := 128
const DEF_LIGHT_SCALE = 64
const PLAYER_LIGHT_SCALE = 48
var mouse_pos : Vector2 = Vector2.ZERO
var mouse_rad := 0.0
var mouse_dir : Vector2 = Vector2.ZERO


var hp = 100


const DEF_SHOOT_CD = 0.1
var shoot_cd = 0.0


var bullet_res = preload("res://src/object/bullets/bullet.tscn")


func _ready():
	$LightPivot.top_level = true


func _process(delta):
	mouse_pos = round(get_global_mouse_position())
	mouse_dir = global_position.direction_to(get_global_mouse_position())

	var lerp_pow = 0.5

	if Input.is_action_pressed("m2"):
		$LightPivot.global_position = lerp($LightPivot.global_position, get_global_mouse_position(), lerp_pow)
		$LightPivot.scale = lerp($LightPivot.scale, float_to_vec(cal_light_scale(DEF_LIGHT_SCALE)), lerp_pow)
	else:
		$LightPivot.global_position = lerp($LightPivot.global_position, global_position, lerp_pow)
		$LightPivot.scale = lerp($LightPivot.scale, float_to_vec(cal_light_scale(PLAYER_LIGHT_SCALE)), lerp_pow)

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

func cal_light_scale(target_rad):
	var p = 1.0/LIGHT_RES

	return p * target_rad

func float_to_vec(n):
	return Vector2(n, n)