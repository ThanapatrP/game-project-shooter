extends Node

# FX Library
const FLOAT_TEXT = preload("res://src/fx/float_text/float_text.tscn")

func spawn_float_text(text : String, glob_pos : Vector2, color : Color = Color.WHITE, text_scale : int = 1):
	var new_float_text = FLOAT_TEXT.instantiate()

	new_float_text.text_color = color
	new_float_text.text_bbcode = text
	new_float_text.global_position = glob_pos
	new_float_text.font_size = text_scale * 8

	get_tree().current_scene.add_child(new_float_text)

