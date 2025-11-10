extends Node


# Player stuff
var player : Player = null


# UI stuff
var camera : Camera2D = null
var cursor = null
var hurt_overlay = null
var score_label = null
var hp_indicator = null
var card_layer : CanvasLayer = null

# Save stuff
var curr_score = 0
var highscore = 0

# Signals
signal pause
signal resume

func add_score(amt):
    if amt < 0:
        return
    
    curr_score += amt
    if score_label: score_label.trigger_impulse_color()


# save load stuff
func load_data():
    pass


func _ready() -> void:
    process_mode = ProcessMode.PROCESS_MODE_ALWAYS

    connect("pause",
    func():
        get_tree().paused = true
    )

    connect("resume",
    func():
        get_tree().paused = false
    )


func _process(delta: float) -> void:
    if Input.is_action_just_pressed("ui_accept"):
        emit_signal("pause")
        if card_layer:
            card_layer.activate_ui()