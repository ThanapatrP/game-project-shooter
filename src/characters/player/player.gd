class_name Player
extends CharacterBody2D


# Movement stuff
const SPD = 100.0
var p_input := Vector2.ZERO
var added_velo : Vector2 = Vector2.ZERO


# Mouse stuff
var mouse_pos : Vector2 = Vector2.ZERO
var mouse_rad := 0.0
var mouse_dir : Vector2 = Vector2.ZERO


# HP stuff
var hp = 100
var invin = -1.0


# Shoot stuff
const DEF_SHOOT_CD = 0.1
var shoot_cd = 0.0
var RELOAD_T = 0.8 # default / max reload cooldown
var reload_cd = -1.0 # currect cooldown of reload
var ammo = 30


# Light stuff
const DEF_LIGHT_POW = 3.5 # how long light will last in second (max)
const LIGHT_RES := 256 # size of light texture
const ACTIVE_LIGHT_SCALE = 128 + 32
const PLAYER_LIGHT_SCALE = 64+16
var light_pow = 0.0
var light_active = true


# Resources
var bullet_res = preload("res://src/object/bullets/bullet.tscn")

var sfx_open_clip = preload("res://asset/sfx/open_clip_sfx.mp3")
var sfx_reload_complete = preload("res://asset/sfx/reload_complete.mp3")


# Node ref
@onready var light_pivot := $LightPivot
@onready var point_light := $LightPivot/PointLight2D
@onready var gun_audio_stream : AudioStreamPlayer = $GunAudioStream
@onready var reload_audio_player : AudioStreamPlayer = $ReloadAudioStream
@onready var reload_loop_audio_player : AudioStreamPlayer = $ReloadingAudioStream


func _ready():
	light_pivot.top_level = true
	light_pivot.global_position = global_position

	light_pow = DEF_LIGHT_POW


func _process(delta):

	# Mouse management
	mouse_pos = round(get_global_mouse_position())
	mouse_dir = global_position.direction_to(get_global_mouse_position())


	var light_lerp_pow = 0.5

	# Active light stuff
	if Input.is_action_pressed("m2") and light_active:
		light_pivot.global_position = lerp($LightPivot.global_position, get_global_mouse_position(), light_lerp_pow)
		light_pivot.scale = lerp($LightPivot.scale, float_to_vec(cal_light_scale(ACTIVE_LIGHT_SCALE)), light_lerp_pow)
		light_pow -= delta
		if light_pow <= 0.0:
			light_active = false
	else:
		light_pivot.global_position = lerp($LightPivot.global_position, global_position, light_lerp_pow)
		light_pivot.scale = lerp($LightPivot.scale, float_to_vec(cal_light_scale(PLAYER_LIGHT_SCALE)), light_lerp_pow)
		light_pow += delta * 2.0
		if light_pow > DEF_LIGHT_POW/2.0:
			light_active = true
			if light_pow > DEF_LIGHT_POW:
				light_pow = DEF_LIGHT_POW

	point_light.energy = 1.0 * (float(light_pow)/DEF_LIGHT_POW)

	shoot_cd -= delta

	# Movement Input
	p_input.x = Input.get_axis("left", "right")
	p_input.y = Input.get_axis("up", "down")

	p_input = p_input.normalized()

	# Shoot
	if Input.is_action_pressed("m1") and reload_cd <= 0.0:
		shoot()
		if ammo <= 0:
			reload_cd = RELOAD_T
			reload_audio_player.stop()
			reload_audio_player.stream = sfx_open_clip
			reload_audio_player.play()
	
	if reload_cd > 0.0:
		reload_cd -= delta
		if reload_cd <= 0.0:
			ammo = 30
			reload_audio_player.stop()
			reload_audio_player.stream = sfx_reload_complete
			reload_audio_player.play()

	if reload_loop_audio_player.playing != (reload_cd > 0.0):
		reload_loop_audio_player.playing = (reload_cd > 0.0)
	
	# On hit
	if $Hitbox.get_overlapping_bodies().size() > 0 and invin <= 0.0:
		hp -= 30
		invin = 3.0

	if invin > 0.0:
		modulate.a = abs(cos(Time.get_ticks_msec()/100.0))
		invin -= delta
	else:
		modulate.a = 1
	


func _physics_process(delta):
	velocity = ( p_input * SPD ) + added_velo

	added_velo = lerp(added_velo, Vector2.ZERO, 0.1)

	move_and_slide()


# Call on shoot pressed (Auto considered cd)
func shoot():
	if shoot_cd > 0.0:
		return
	
	var bullet : Area2D = bullet_res.instantiate()
	bullet.global_position = global_position
	bullet.dir = mouse_dir

	get_tree().current_scene.add_child(bullet)

	shoot_cd = DEF_SHOOT_CD
	ammo -= 1

	var cam = get_node_or_null("%Camera2D")
	if cam: cam.shake(0.2, 5)

	gun_audio_stream.play()

func cal_light_scale(target_rad):
	var p = 1.0/LIGHT_RES

	return p * target_rad

func float_to_vec(n):
	return Vector2(n, n)
