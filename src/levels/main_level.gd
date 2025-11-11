extends Node2D


func _ready() -> void:
	# setup singleton node ref
	Global.main_level = self
	Global.invert_text = $UILayer/InvertText

func _exit_tree() -> void:
	Global.main_level = null
	Global.invert_text = null
