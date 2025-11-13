extends CanvasLayer


@onready var digit_score_label : RichTextLabel = $ScoreDigitLabel

@onready var animation_player : AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("StartDisplay")

	await animation_player.animation_finished

	countup_digit_score()


func countup_digit_score():
	var score_digit : int = 0
	while score_digit < Global.curr_score:
		score_digit += ceil((Global.curr_score - score_digit) * 0.3)
		score_digit = ceil(score_digit)

		digit_score_label.text = var_to_str(score_digit)

		await get_tree().create_timer(1.0/60.0).timeout
	

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("spacebar"):
		get_tree().change_scene_to_file("res://src/levels/main_level.tscn")
