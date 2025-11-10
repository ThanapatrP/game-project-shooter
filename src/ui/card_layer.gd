extends CanvasLayer


var active = false
var ex_cursor = 0

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
		
		if Input.is_action_just_pressed("m1") and hovering_card != null:
			if hovering_card.curse != null and Global.player != null:
				hovering_card.curse.apply(Global.player)

			deactivate_ui()
   
func activate_ui():
	
	ex_cursor = Global.cursor.active_cursor_sprite

	if Global.cursor:
		Global.cursor.set_cursor_sprite(Global.cursor.Cursor.POINT)
		Global.cursor.set_cursor_text("")

	active = true
	visible = true

	# TODO: Randomize curse stuff
	# TODO: animate stuff

	Global.emit_signal("pause")

			
func deactivate_ui():
	active = false
	visible = false

	# TODO: animate stuff

	Global.emit_signal("resume")
	if Global.cursor:
		Global.cursor.set_cursor_sprite(ex_cursor)
