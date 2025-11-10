extends Node2D

var hover : bool = false
var curse : Curse = null

@onready var mouse_area : Area2D = $MouseArea


func _ready() -> void:
	mouse_area.connect("mouse_entered",
	func():
		hover = true
		if Global.cursor != null:
			Global.cursor.set_cursor_transform(Vector2(1.4, 1.4), 0)
	)

	mouse_area.connect("mouse_exited",
	func():
		hover = false
	)

func _process(delta: float) -> void:
	if hover:
		modulate = Color.RED
	else:
		modulate = Color.WHITE
