extends MinigameBase

var targets_clicked: int = 0
var targets_required: int = 5
var target_spawn_timer: float = 0.0
var target_spawn_interval: float = 0.8

@onready var targets_node = $Targets

func _on_minigame_start():
	time_limit = 5.0
	instruction_text = "TAP!"

func _process(delta):
	super._process(delta)
	if not is_active:
		return

	target_spawn_timer += delta
	if target_spawn_timer >= target_spawn_interval:
		target_spawn_timer = 0.0
		_spawn_target()

func _spawn_target():
	var is_bomb = randf() < 0.2
	var target = ColorRect.new()
	target.size = Vector2(50, 50)
	target.position = Vector2(randf_range(50, 1230), randf_range(50, 670))

	if is_bomb:
		target.color = Color(0.9, 0.2, 0.2)
		target.set_meta("is_bomb", true)
	else:
		target.color = Color(0.3, 0.9, 0.3)
		target.set_meta("is_bomb", false)

	targets_node.add_child(target)

	var tween = create_tween()
	tween.tween_property(target, "modulate:a", 0.0, 1.5)
	tween.tween_callback(target.queue_free)

func _input(event):
	if not is_active:
		return

	if event is InputEventMouseButton and event.pressed:
		for target in targets_node.get_children():
			var target_rect = Rect2(target.position, target.size)
			if target_rect.has_point(event.position):
				if target.get_meta("is_bomb"):
					lose()
				else:
					targets_clicked += 1
					target.queue_free()
					if targets_clicked >= targets_required:
						win()
				break
