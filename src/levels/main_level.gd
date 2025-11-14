extends Node2D

# TUTORIAL
enum TUTORIAL_STATE{
	NONE,
	MOVEMENT,
	SHOOT,
	LIGHT,
	KILLEM,
}
var curr_tutorial_state = TUTORIAL_STATE.MOVEMENT
var player_complete_step = false

var wasd_sprite_frame : SpriteFrames = preload("res://src/ui/tutorial/sprite_frame/wasd_sprite_frame.tres")
var m1_sprite_frame : SpriteFrames = preload("res://src/ui/tutorial/sprite_frame/m1_sprite_frame.tres")
var m2_sprite_frame : SpriteFrames = preload("res://src/ui/tutorial/sprite_frame/m2_sprite_frame.tres")

var dead_layer = preload("res://src/ui/dead_layer.tscn")

@onready var generic_label : RichTextLabel = $GenericLabel
@onready var generic_sprite : AnimatedSprite2D = $GenericSprite

@onready var center_light : Light2D = $CenterLight

func _ready() -> void:
	# setup singleton node ref
	Global.main_level = self
	Global.invert_text = $UILayer/InvertText

	$Spawner.set_physics_process(false)
	$Spawner.set_process(false)

	$UILayer/ImpactFrame.visible = false

	$UILayer/FadeOutRect.color.a = 1.0
	var tween := create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property($UILayer/FadeOutRect, "color:a", 0.0, 0.8)


func _exit_tree() -> void:
	Global.main_level = null
	Global.invert_text = null


func _process(delta: float) -> void:
	if Global.invert_text:
		Global.invert_text.get_node("AnimationPlayer").speed_scale = 1.0 / Engine.time_scale
	if Global.debug:
		pass
		# print($UILayer/InvertText.visible)
	
	if curr_tutorial_state != TUTORIAL_STATE.NONE:
		if Input.is_action_just_pressed("spacebar"):
			curr_tutorial_state = TUTORIAL_STATE.KILLEM

			var tween := create_tween()
			tween.set_ease(Tween.EASE_IN_OUT)
			tween.set_trans(Tween.TRANS_SINE)
			tween.tween_property(center_light, "scale", Vector2(), 0.7)

		tutorial_queue()

func restart():
	$UILayer/ImpactFrame.visible = true

	await get_tree().create_timer(3.0/60.0).timeout

	$UILayer/ImpactFrame.color = Color.RED

	await get_tree().create_timer(3.0/60.0).timeout

	for node in get_children():
		node.queue_free()

	add_child(dead_layer.instantiate())

func tutorial_queue():
	match curr_tutorial_state:
		TUTORIAL_STATE.MOVEMENT:
			if !player_complete_step:
				generic_sprite.visible = true
			generic_sprite.sprite_frames = wasd_sprite_frame
			if !generic_sprite.is_playing():
				generic_sprite.play("default")
			if Global.player:
				generic_sprite.global_position = Global.player.global_position + Vector2(-28, -57)
			
			if (Input.is_action_just_pressed("right") or
				Input.is_action_just_pressed("left") or
				Input.is_action_just_pressed("up") or
				Input.is_action_just_pressed("down")) and !player_complete_step:

					player_complete_step = true

					generic_sprite.visible = false
					await get_tree().create_timer(0.5).timeout

					curr_tutorial_state = TUTORIAL_STATE.SHOOT

					player_complete_step = false

		TUTORIAL_STATE.SHOOT:
			if !player_complete_step:
				generic_sprite.visible = true
			generic_sprite.sprite_frames = m1_sprite_frame

			if !generic_sprite.is_playing():
				generic_sprite.play("default")
			if Global.player:
				generic_sprite.global_position = Global.player.global_position + Vector2(-10, -43)

			if Input.is_action_just_pressed("m1") and !player_complete_step:
				player_complete_step = true

				generic_sprite.visible = false
				await get_tree().create_timer(0.4).timeout

				var tween := create_tween()
				tween.set_ease(Tween.EASE_IN_OUT)
				tween.set_trans(Tween.TRANS_SINE)
				tween.tween_property(center_light, "scale", Vector2(), 0.7)

				await tween.finished

				curr_tutorial_state = TUTORIAL_STATE.LIGHT

				player_complete_step = false

		TUTORIAL_STATE.LIGHT:
			if !player_complete_step:
				generic_sprite.visible = true
			generic_sprite.sprite_frames = m2_sprite_frame

			if !generic_sprite.is_playing():
				generic_sprite.play("default")
			if Global.player:
				generic_sprite.global_position = get_global_mouse_position() + Vector2(-10, -43)

			if Input.is_action_just_pressed("m2") and !player_complete_step:
				player_complete_step = true

				generic_sprite.visible = false
				await get_tree().create_timer(0.4).timeout

				curr_tutorial_state = TUTORIAL_STATE.KILLEM

		TUTORIAL_STATE.KILLEM:
				if Global.invert_text:
					generic_sprite.visible = false

					Global.invert_text.get_node("AnimationPlayer").play("KillEm")
					await Global.invert_text.get_node("AnimationPlayer").animation_finished

					Global.invert_text.visible = false

				$Spawner.set_physics_process(true)
				$Spawner.set_process(true)

				$Spawner.curr_spawn_t = 1

				curr_tutorial_state = TUTORIAL_STATE.NONE

				player_complete_step = false
