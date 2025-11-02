extends Node2D


enum Cursor {
	CROSSHAIR,
	RELOADING,
}

var active_cursor_sprite = Cursor.CROSSHAIR

var _cursor_texture = [
	preload("res://asset/ui/cursor/crosshair_cursor.png"),
	preload("res://asset/ui/cursor/reload_cursor.png"),
]


var progress = 0.0
var cursor_label_text = ""


@onready var cursor_sprite : Sprite2D = $CursorSpr
@onready var cursor_label : RichTextLabel = $CursorLabel


func _ready() -> void:
	# set global cursor to self
	if Global.cursor == null:
		Global.cursor = self
	elif Global.cursor != self:
		Global.cursor.queue_free()
		Global.cursor = self

	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

	
func _process(delta: float) -> void:
	queue_redraw()
	cursor_sprite.texture = _cursor_texture[active_cursor_sprite]

	# global_position = round(get_global_mouse_position())

func _physics_process(delta):
	cursor_sprite.scale = lerp(cursor_sprite.scale, Vector2(1, 1), 0.1)
	cursor_sprite.rotation_degrees = lerp(cursor_sprite.rotation_degrees, 0.0, 0.1)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		global_position = round(event.global_position)


func set_cursor_sprite(cursor_spr : Cursor):
	active_cursor_sprite = cursor_spr


func set_cursor_transform(size : Vector2, rot_deg : float):
	cursor_sprite.scale = size
	cursor_sprite.rotation_degrees = rot_deg


func set_progress(new_progress : float):
	progress = clamp(new_progress, 0.0, 1.0)


func set_cursor_text(text : String):
	cursor_label.text = text


func _draw() -> void:
	draw_arc(Vector2(0.5, 0.5), 9.0 * cursor_sprite.scale.x, 0.0, (PI * 2 * progress) - 0.01, 16, Color.WHITE, 2, false)


func _exit_tree() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
