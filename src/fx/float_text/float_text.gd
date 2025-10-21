extends Node2D

var text_color = Color.WHITE
var text_bbcode = "HELLOWORLD!"

var life_t = 0.0
var mx_life_t = -1.0
const DEF_LIFE_T = 0.3

var speed = -1.0
const DEF_SPD = 150.0

var font_size = 8

@onready var text_label : RichTextLabel = $Label

func _ready() -> void:
    if mx_life_t < 0.0:
        mx_life_t = DEF_LIFE_T
    life_t = mx_life_t

    if speed < 0:
        speed = DEF_SPD

    text_label.text = text_bbcode;

    text_label.add_theme_color_override("default_color", text_color)
    text_label.add_theme_font_size_override("normal_font_size", font_size);


func _process(delta: float) -> void:
    if life_t <= 0.0:
        queue_free()

    global_position.y -= speed * delta

    life_t -= delta


func _physics_process(delta: float) -> void:
    speed = speed * 0.85

    var fade_threshold = 0.4

    if (life_t / mx_life_t) < fade_threshold:
            modulate.a = (life_t / (mx_life_t*fade_threshold))