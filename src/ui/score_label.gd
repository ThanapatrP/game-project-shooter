extends RichTextLabel

var normal_color : Color = Color.WHITE
var impulse_color : Color = Color.RED

var impulse_t : float = 0.0
var mx_impulse_t : float = 1.0

func _enter_tree() -> void:
    Global.score_label = self

func _process(delta):
    impulse_t -= delta

    if impulse_t < 0:
        impulse_t = 0.0

    var curr_color = normal_color.lerp(impulse_color, clamp((impulse_t / mx_impulse_t), 0.0, 1.0))

    text = "SCORE : [color=#%s]%d" % [curr_color.to_html(), Global.curr_score]

# func _physics_process(delta: float) -> void:
#     shake_intensity = shake_intensity * 0.9

func trigger_impulse_color(new_t : float = 0.3):
    mx_impulse_t = new_t
    impulse_t = new_t

func _exit_tree() -> void:
    Global.score_label = null