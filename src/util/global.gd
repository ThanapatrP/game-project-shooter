extends Node


# Player stuff
var player : Player = null

# mainlevel stuff
var main_level : Node2D = null

# UI stuff
var camera : Camera2D = null
var cursor = null
var hurt_overlay = null
var score_label = null
var hp_indicator = null
var card_layer : CanvasLayer = null
var invert_text : RichTextLabel = null

# Score stuff
var curr_score = 0
var highscore = 0
var next_card_score = 0
var score_stack = 0
var next_stack_mult = 1.0
const DEF_NEXT_CARD_SCORE = 500
const DEF_NEXT_STACK_MULT = 1.2

var player_card = 0

# Signals
signal pause
signal resume

# Debug
var debug = true


func add_score(amt):
	if amt < 0:
		return
	
	curr_score += amt
	score_stack += amt

	if score_stack > next_card_score:
		score_stack = 0
		next_card_score *= 1.2
		if card_layer: # next card
			var tween := create_tween()
			tween.set_ignore_time_scale()

			if invert_text:
				print("play!")
				invert_text.get_node("AnimationPlayer").play("LevelUpBlink")

			await tween.tween_property(Engine, "time_scale", 0.01, 0.7).finished

			invert_text.get_node("AnimationPlayer").stop()
			invert_text.get_node("AnimationPlayer").speed_scale = 1.0
			invert_text.visible = false
			get_tree().paused = true

			if debug:
				pass
				# print("FINISH")

			Engine.time_scale = 1.0

			card_layer.activate_ui()

	if score_label:
		score_label.trigger_impulse_color()


func reset_score():
	curr_score = 0
	next_card_score = DEF_NEXT_CARD_SCORE
	score_stack = 0
	next_stack_mult = DEF_NEXT_STACK_MULT
	player_card = 0

# save load stuff
func load_data():
	pass


func _ready() -> void:
	reset_score()

	process_mode = ProcessMode.PROCESS_MODE_ALWAYS

	connect("pause",
	func():
		get_tree().paused = true
	)

	connect("resume",
	func():
		get_tree().paused = false
	)


# func _process(delta: float) -> void:
#     if Input.is_action_just_pressed("ui_accept"):
#         emit_signal("pause")
#         if card_layer:
#             card_layer.activate_ui()
