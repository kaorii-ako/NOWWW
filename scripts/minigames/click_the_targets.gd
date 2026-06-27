extends MinigameBase

var targets_clicked: int = 0
var targets_required: int = 5
var target_spawn_timer: float = 0.0
var target_spawn_interval: float = 0.5
var click_cooldown: float = 0.0

@onready var targets_node = $Targets

func _on_minigame_start():
	time_limit = 10.0
	instruction_text = "TAP!"

func _process(delta):
	super._process(delta)
	if not is_active:
		return

	click_cooldown -= delta
	target_spawn_timer += delta
	if target_spawn_timer >= target_spawn_interval:
		target_spawn_timer = 0.0
		_spawn_target()

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and click_cooldown <= 0.0:
		click_cooldown = 0.15
		_handle_click()

func _spawn_target():
	var is_bomb = randf() < 0.2
	var target = ColorRect.new()
	target.size = Vector2(50, 50)
	target.position = Vector2(randf_range(50, 1230), randf_range(50, 670))

	if is_bomb:
		target.color = Color(1.0, 0.0, 0.0)
		target.set_meta("is_bomb", true)
	else:
		var colors = [
			Color(0.0, 1.0, 0.5),
			Color(0.0, 0.8, 1.0),
			Color(1.0, 1.0, 0.0),
			Color(1.0, 0.5, 0.0),
			Color(0.5, 0.0, 1.0)
		]
		target.color = colors[randi() % colors.size()]
		target.set_meta("is_bomb", false)

	targets_node.add_child(target)

	var tween = create_tween()
	tween.tween_property(target, "modulate:a", 0.0, 1.5)
	tween.tween_callback(target.queue_free)

func _handle_click():
	var mouse_pos = get_viewport().get_mouse_position()
	for target in targets_node.get_children():
		var target_rect = Rect2(target.position, target.size)
		if target_rect.has_point(mouse_pos):
			if target.get_meta("is_bomb"):
				lose()
			else:
				targets_clicked += 1
				target.queue_free()
				if targets_clicked >= targets_required:
					win()
			break
