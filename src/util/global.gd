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
var next_card_score = 300
var score_stack = 0
var next_stack_mult = 1.2

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
				invert_text.get_node("AnimationPlayer").play("LevelUpBlink")

			await tween.tween_property(Engine, "time_scale", 0.0, 0.7).finished
			get_tree().paused = true

			if debug:
				print("FINISH")

			Engine.time_scale = 1.0

			card_layer.activate_ui()

	if score_label:
		score_label.trigger_impulse_color()


func reset_score():
	curr_score = 0
	next_card_score = 300
	score_stack = 0
	next_stack_mult = 1.2

# save load stuff
func load_data():
	pass


func _ready() -> void:
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
