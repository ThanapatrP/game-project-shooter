extends Sprite2D

var mx_t = 0.0
var t = 0.0

func _enter_tree() -> void:
    Global.hurt_overlay = self

func start(time : float = 0.7):
    mx_t = time
    t = time

func _process(delta: float) -> void:
    if t > 0:
        t -= delta
        if t < 0.0:
            t = 0.0

        modulate.a = clamp(t/mx_t, 0.0, 1.0)
    else:
        modulate.a = 0.0

func _exit_tree() -> void:
    Global.hurt_overlay = null