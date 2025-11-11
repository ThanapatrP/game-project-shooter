extends CanvasLayer


var active = false
var ex_cursor = 0
var selected = false

var curses = [
	preload("res://src/object/card/curse_res/dmg_mult_curse.tres"),
	preload("res://src/object/card/curse_res/reload_amp_curse.tres"),
	preload("res://src/object/card/curse_res/reload_amp_curse.tres"), # TEMP
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
	assign_shuffle()

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
				hovering_card.curse.apply(Global.player)
				
				# JUICE
				hovering_card.flash()
				hovering_card.sprite_pivot.scale = Vector2(1.2, 1.2)
				hovering_card.sprite_pivot.rotation_degrees = 15

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

	# TODO: Randomize curse stuff
	# TODO: animate stuff

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

	cards[0].curse = shuffled_curses[0]
	cards[1].curse = shuffled_curses[1]
	cards[2].curse = shuffled_curses[2]

	shuffled_curses.clear()