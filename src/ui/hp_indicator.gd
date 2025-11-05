extends Node2D

const SHAKE_INTENSITY = 8
const DEF_SHAKE_DUR := 0.8
var shake_t := 0.0

const DEF_SPR_DUR := 0.3
var spr_t := 0.0

var curr_progress = 1.1
var to_progress = 1.0 

var green := Color(0,1,0,1)
var red := Color(1,0,0,1)
var col := Color(0,1,0,1)

@onready var pivot : Marker2D = $Pivot
@onready var idle_icon : Sprite2D = $Pivot/IdleIcon
@onready var hurt_icon : Sprite2D = $Pivot/HurtIcon

func _ready() -> void:
	Global.hp_indicator = self


func _process(delta: float) -> void:
	shake_t -= delta
	spr_t -= delta

	if shake_t < 0.0:
		shake_t = 0.0

	if spr_t < 0.0:
		spr_t = 0.0

	# Sprite shake position
	position.x = SHAKE_INTENSITY * cos(shake_t * 100.0) * (shake_t / DEF_SHAKE_DUR)
	
	# Progress 
	idle_icon.material.set_shader_parameter("progress", to_progress)
	hurt_icon.material.set_shader_parameter("progress", to_progress)

	idle_icon.material.set_shader_parameter("follow_progress", curr_progress)
	hurt_icon.material.set_shader_parameter("follow_progress", curr_progress)

	# Sprite switching
	if spr_t > 0.0:
		idle_icon.visible = false
		hurt_icon.visible = true
	else:
		idle_icon.visible = true
		hurt_icon.visible = false

func _physics_process(delta: float) -> void:
	curr_progress = lerp(curr_progress, to_progress, 0.07)
	print(to_progress)


func shake():
	shake_t = DEF_SHAKE_DUR
	spr_t = DEF_SPR_DUR


func set_progress(new_progress : float):
	if new_progress > curr_progress:
		curr_progress = new_progress
	to_progress = new_progress

	var threshold = 0.6
	if to_progress > threshold:
		col = green
	else:
		col = red.lerp(green, to_progress / threshold)
	
	idle_icon.material.set_shader_parameter("primary_color", col)
	hurt_icon.material.set_shader_parameter("primary_color", col)

	var dimmed_col : Color = col
	dimmed_col.v *= 0.7

	idle_icon.material.set_shader_parameter("secondary_color", dimmed_col)
	hurt_icon.material.set_shader_parameter("secondary_color", dimmed_col)



func _exit_tree() -> void:
	Global.hp_indicator = null