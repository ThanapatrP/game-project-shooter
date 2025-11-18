class_name Curse
extends Resource


@export var curse_icon : Texture2D = null
@export var display_name : String = "NAME"


func apply(player : Player): # Apply curse to player
	pass

func get_desc() -> String:
	return "DESC"

func update_info():
	pass
