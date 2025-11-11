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
var MAX_HP = 100.0
var hp = 100.0
var invin = -1.0


# Shoot stuff
var DEF_SHOOT_CD = 0.1
var shoot_cd = 0.0
var RELOAD_T = 0.8 # default / max reload cooldown
var reload_cd = -1.0 # currect cooldown of reload
var ammo = 30
var MAX_AMMO = 30

var bullet_dmg_mult : float = 1.0


# Light stuff
var DEF_LIGHT_POW = 3.5 # how long light will last in second (max)
const LIGHT_RES := 256 # size of light texture (NO CHANGE DURING GAMEPLAY!!)
var ACTIVE_LIGHT_SCALE = 128 + 32
var PLAYER_LIGHT_SCALE = 128 - 32
var light_pow = 0.0
var light_active = true # if true - player still can use m2 to use light


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

func _enter_tree() -> void:
	Global.player = self


func _exit_tree() -> void:
	Global.player = null


func _ready():
	light_pivot.top_level = true
	light_pivot.global_position = global_position

	light_pow = DEF_LIGHT_POW

	ammo = MAX_AMMO


func _process(delta):

	# Mouse management
	mouse_pos = round(get_global_mouse_position())
	mouse_dir = global_position.direction_to(get_global_mouse_position())


	# var light_lerp_pow = 0.5

	# # Active light stuff
	# if Input.is_action_pressed("m2") and light_active:
	# 	light_pivot.global_position = lerp($LightPivot.global_position, get_global_mouse_position(), light_lerp_pow)
	# 	light_pivot.scale = lerp($LightPivot.scale, float_to_vec(cal_light_scale(ACTIVE_LIGHT_SCALE)), light_lerp_pow)
	# 	light_pow -= delta
	# 	if light_pow <= 0.0:
	# 		light_active = false
	# else:
	# 	light_pivot.global_position = lerp($LightPivot.global_position, global_position, light_lerp_pow)
	# 	light_pivot.scale = lerp($LightPivot.scale, float_to_vec(cal_light_scale(PLAYER_LIGHT_SCALE)), light_lerp_pow)
	# 	light_pow += delta * 2.0
	# 	if light_pow > DEF_LIGHT_POW/2.0:
	# 		light_active = true
	# 		if light_pow > DEF_LIGHT_POW:
	# 			light_pow = DEF_LIGHT_POW

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
			if Global.cursor:
				Global.cursor.set_cursor_sprite(Global.cursor.Cursor.RELOADING)
				Global.cursor.set_cursor_transform(Vector2(2.1, 2.1), -30)
			reload_cd = RELOAD_T
			reload_audio_player.stop()
			reload_audio_player.stream = sfx_open_clip
			reload_audio_player.play()
	
	if reload_cd > 0.0:
		reload_cd -= delta
		if Global.cursor:
			Global.cursor.set_progress(reload_cd / RELOAD_T)
			Global.cursor.set_cursor_text("[wave amp=50.0 freq=10.0 connected=0]RELOADING")
		if reload_cd <= 0.0:
			if Global.cursor:
				Global.cursor.set_cursor_sprite(Global.cursor.Cursor.CROSSHAIR)
				Global.cursor.set_cursor_transform(Vector2(2.1, 2.1), -30)
			ammo = MAX_AMMO
			reload_audio_player.stop()
			reload_audio_player.stream = sfx_reload_complete
			reload_audio_player.play()
	else:
		if Global.cursor:
			if ammo < MAX_AMMO * 0.3:
				Global.cursor.set_cursor_text("[color=ORANGE]%d[/color]/%d" % [ammo, MAX_AMMO])
			else:
				Global.cursor.set_cursor_text("%d/%d" % [ammo, MAX_AMMO])

	if reload_loop_audio_player.playing != (reload_cd > 0.0):
		reload_loop_audio_player.playing = (reload_cd > 0.0)
	
	# On hit
	if $Hitbox.get_overlapping_bodies().size() > 0 and invin <= 0.0:
		if Global.hurt_overlay:
			Global.hurt_overlay.start()

		if Global.camera:
			Global.camera.shake(0.5, 15)
			Global.hp_indicator.shake()

		hp -= 30
		invin = 3.0

		Global.hp_indicator.set_progress(hp / MAX_HP)

	if hp > MAX_HP:
		hp = MAX_HP

	if invin > 0.0:
		modulate.a = abs(cos(Time.get_ticks_msec()/100.0))
		invin -= delta
	else:
		modulate.a = 1
	


func _physics_process(delta):
	var light_lerp_pow = 0.5

	# Active light stuff
	if Input.is_action_pressed("m2") and light_active:
		light_pivot.global_position = lerp($LightPivot.global_position, get_global_mouse_position(), light_lerp_pow * delta * 60)
		light_pivot.scale = lerp($LightPivot.scale, float_to_vec(cal_light_scale(ACTIVE_LIGHT_SCALE)), light_lerp_pow * delta * 60)
		light_pow -= delta
		if light_pow <= 0.0:
			light_active = false
	else:
		light_pivot.global_position = lerp($LightPivot.global_position, global_position, light_lerp_pow * delta * 60)
		light_pivot.scale = lerp($LightPivot.scale, float_to_vec(cal_light_scale(PLAYER_LIGHT_SCALE)), light_lerp_pow * delta * 60)
		light_pow += delta * 2.0
		if light_pow > DEF_LIGHT_POW/2.0:
			light_active = true
			if light_pow > DEF_LIGHT_POW:
				light_pow = DEF_LIGHT_POW

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

	bullet.damage *= bullet_dmg_mult # apply damage mult

	get_tree().current_scene.add_child(bullet)

	shoot_cd = DEF_SHOOT_CD
	ammo -= 1

	if Global.camera: Global.camera.shake(0.2, 5)

	gun_audio_stream.play()

	if Global.cursor: Global.cursor.set_cursor_transform(Vector2(2, 2), randf_range(-30, 30))

func cal_light_scale(target_rad):
	var p = 1.0/LIGHT_RES

	return p * target_rad

func float_to_vec(n):
	return Vector2(n, n)

func apply_cursor():
	if Global.cursor != null:
		pass
