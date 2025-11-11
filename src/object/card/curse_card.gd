extends Node2D

var can_hover : bool = true
var hover : bool = false
var curse : Curse = null
var selected : bool = false

@onready var mouse_area : Area2D = $MouseArea
@onready var sprite_pivot : Node2D = $SpritePivot
@onready var card_spr : Node2D = $SpritePivot/CardSprite
@onready var card_spr_flash : Node2D = $SpritePivot/CardSpriteFlash
@onready var curse_icon : Sprite2D = $SpritePivot/Icon
@onready var curse_display_name : RichTextLabel = $SpritePivot/Name
@onready var curse_desc : RichTextLabel = $SpritePivot/Desc

func _ready() -> void:
	mouse_area.connect("mouse_entered",
	func():
		if can_hover:
			hover = true
			sprite_pivot.rotation_degrees = -15.0
			if Global.cursor != null:
				Global.cursor.set_cursor_transform(Vector2(1.4, 1.4), 0)
	)

	mouse_area.connect("mouse_exited",
	func():
		hover = false
	)


func _process(delta: float) -> void:
	if curse != null:
		curse_icon.texture = curse.curse_icon
		curse_display_name.text = curse.display_name
		curse_desc.text = curse.desc



func _physics_process(delta: float) -> void:
	sprite_pivot.rotation_degrees = lerp(sprite_pivot.rotation_degrees, 0.0, 0.35)

	var small_scale = 0.7
	var small_scale_vec = Vector2(small_scale, small_scale)

	if hover or selected:
		sprite_pivot.scale = lerp(sprite_pivot.scale, Vector2(1,1), 0.35)
		card_spr.material.set_shader_parameter("outline", true)
	else:
		sprite_pivot.scale = lerp(sprite_pivot.scale, small_scale_vec, 0.35)
		card_spr.material.set_shader_parameter("outline", false)
	
	card_spr_flash.material.set_shader_parameter("colorize", card_spr_flash.material.get_shader_parameter("colorize") * 0.8)


func flash():
	card_spr_flash.material.set_shader_parameter("colorize", 1.0)