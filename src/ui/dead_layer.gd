extends CanvasLayer


var can_restart = false

@onready var digit_score_label : RichTextLabel = $ScoreDigitLabel
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var old_highscore_digit_label : RichTextLabel = $OldHighscoreDigitLabel

func _ready() -> void:
	if Global.running_tween:
		Global.running_tween.kill()

	Engine.time_scale = 1.0
	get_tree().paused = false

	old_highscore_digit_label.text = var_to_str(ceil(Global.highscore))

	animation_player.play("StartDisplay")

	await animation_player.animation_finished

	countup_digit_score()

	await get_tree().create_timer(1.2).timeout

	can_restart = true

func countup_digit_score():
	if Global.curr_score == 0:
		var roast_text = [
			"Gid Gud",
			"NOOB",
			"กาก",
			"(‿|‿)",
		]
		randomize()
		digit_score_label.text = roast_text.pick_random()

		await get_tree().create_timer(0.8).timeout
	else:
		digit_score_label.text = "0"

		var score_digit : int = 0
		while score_digit < Global.curr_score:
			score_digit += ceil((Global.curr_score - score_digit) * 0.3)
			score_digit = ceil(score_digit)

			digit_score_label.text = var_to_str(score_digit)

			await get_tree().create_timer(1.0/60.0).timeout
	
	if Global.curr_score == Global.highscore and Global.curr_score != 0:
		animation_player.play("NewHighscore")
	else:
		animation_player.play("NotNewHighscore")
	

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("spacebar") and can_restart:
		Global.reset_score()
		get_tree().change_scene_to_file("res://src/levels/main_level.tscn")
