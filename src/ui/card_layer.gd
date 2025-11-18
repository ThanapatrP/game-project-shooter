extends CanvasLayer


var active = false
var ex_cursor = 0
var selected = false

var curses = [
	preload("res://src/object/card/curse_res/dmg_mult_curse.tres"),
	preload("res://src/object/card/curse_res/reload_amp_curse.tres"),
	preload("res://src/object/card/curse_res/invin_trade_curse.tres"),
	preload("res://src/object/card/curse_res/uzi_trait_curse.tres"),
	preload("res://src/object/card/curse_res/longer_light_curse.tres"),
	preload("res://src/object/card/curse_res/bigger_light_curse.tres"),
]

@onready var cards : Array[Node2D] = [
	$CurseCard1,
	$CurseCard2,
	$CurseCard3,
]

func _enter_tree() -> void:
	Global.card_layer = self


func _exit_tree() -> void:
	Global.card_layer = null


func _ready() -> void:

	visible = active


func _process(delta: float) -> void:
	if active:
		var hovering_card = null

		for c in cards:
			if c.hover:
				hovering_card = c
				break
		
		if Input.is_action_just_pressed("m1") and hovering_card != null and selected == false:
			if hovering_card.curse != null and Global.player != null:
				
				for c in cards:
					if c != hovering_card:
						var tween := create_tween()
						tween.set_ease(Tween.EASE_OUT)
						tween.set_trans(Tween.TRANS_SINE)
						tween.tween_property(c.sprite_pivot.material, "shader_parameter/dissolve_level", 0.0, 0.35)

				hovering_card.curse.apply(Global.player)
				Global.player_card += 1
				
				# JUICE
				randomize()
				var juice_rot_deg = 5
				hovering_card.flash()
				hovering_card.sprite_pivot.scale = Vector2(0.6, 0.6)
				hovering_card.sprite_pivot.rotation_degrees = randf_range(-juice_rot_deg, juice_rot_deg)

				if Global.cursor:
					Global.cursor.set_cursor_transform(Vector2(1.2,1.2), -5)

				for c in cards:
					c.can_hover = false

				selected = true
				hovering_card.selected = true

				await get_tree().create_timer(0.5).timeout

			deactivate_ui()
   
func activate_ui():
	
	ex_cursor = Global.cursor.active_cursor_sprite

	if Global.cursor:
		Global.cursor.set_cursor_sprite(Global.cursor.Cursor.POINT)
		Global.cursor.set_cursor_text("")
		Global.cursor.set_progress(0)

	active = true
	visible = true

	for c in cards:
		c.can_hover = true
		c.sprite_pivot.material.set_shader_parameter("dissolve_level", 1.0);

	# TODO: Randomize curse stuff
	# TODO: animate stuff

	assign_shuffle()
	Global.emit_signal("pause")

			
func deactivate_ui():
	active = false
	visible = false
	selected = false

	for c in cards:
		c.can_hover = false

	for c in cards:
		c.selected = false

	# TODO: animate stuff

	Global.emit_signal("resume")
	if Global.cursor:
		Global.cursor.set_cursor_sprite(ex_cursor)


func assign_shuffle():
	randomize()
	var shuffled_curses = curses.duplicate()
	shuffled_curses.shuffle()

	shuffled_curses[0].update_info()
	shuffled_curses[1].update_info()
	shuffled_curses[2].update_info()

	cards[0].curse = shuffled_curses[0]
	cards[1].curse = shuffled_curses[1]
	cards[2].curse = shuffled_curses[2]

	shuffled_curses.clear()
