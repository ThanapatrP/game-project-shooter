extends Enemy

var flashing_t = -1.0

func _ready() -> void:
	damage = 50
	kb_mult = 2.5
	$PositionMarker.self_modulate.a = 1.0

func _process(delta):
	if($PositionMarker.self_modulate.a > 0):
		$PositionMarker.self_modulate.a = lerp($PositionMarker.self_modulate.a, 0.0, 0.1)

	if follow == null:
		if get_tree().current_scene.get_node_or_null("%Player"):
			follow = get_tree().current_scene.get_node_or_null("%Player")

	if flashing_t > 0.0:
		$FlashingSpr.visible = true
	else:
		$FlashingSpr.visible = false

	flashing_t -= delta


func _physics_process(delta):
	if follow != null:
		apply_vel(follow.global_position)
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()

func hurt(kb_dir : Vector2, damage : float, auto_free : bool = true):
	flashing_t = 0.04
	spd *= 1.4 # faster if took damage
	kb_mult *= 0.7
	super(kb_dir, damage)
