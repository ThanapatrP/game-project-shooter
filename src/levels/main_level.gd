extends Node2D


func _ready() -> void:
	# setup singleton node ref
	Global.main_level = self
	Global.invert_text = $UILayer/InvertText

func _exit_tree() -> void:
	Global.main_level = null
	Global.invert_text = null


func _process(delta: float) -> void:
	$UILayer/InvertText/AnimationPlayer.speed_scale = 1.0 / Engine.time_scale
	if Global.debug:
		print($UILayer/InvertText.visible)
