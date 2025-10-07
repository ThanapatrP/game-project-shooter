extends Camera2D


var shake_t : float = 0.0
var _curr_shake_t : float = 0.0
var shake_intensity : float = 0.0


func _ready() -> void:
    pass


func _process(delta: float) -> void:
    if shake_t > 0:
        randomize()
        var rand_rad = randf() * 2 * PI

        var offset_length = clamp((_curr_shake_t/shake_t), 0.0, 1.0) * shake_intensity

        offset = Vector2(cos(rand_rad) * offset_length, sin(rand_rad) * offset_length)

        _curr_shake_t -= delta
    else:
        offset = Vector2()
        

func _physics_process(delta: float) -> void:
    pass


func shake(duration : float, intensity : float):
    shake_t = duration
    _curr_shake_t = shake_t

    shake_intensity = intensity