extends Control

func _ready():
	modulate = Color.BLACK
	$ScoreLabel.text = "SCORE: %d" % Global.score
	_animate_entrance()
	$RetryButton.pressed.connect(_on_retry)
	$QuitButton.pressed.connect(_on_quit)

func _animate_entrance():
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.5)
	tween.tween_callback(_shake_screen)
	tween.tween_method(_typewriter_title, 0, 10, 1.0)

func _shake_screen():
	var original_pos = position
	var shake_tween = create_tween()
	for i in range(6):
		var offset = Vector2(randf_range(-8, 8), randf_range(-8, 8))
		shake_tween.tween_property(self, "position", original_pos + offset, 0.05)
	shake_tween.tween_property(self, "position", original_pos, 0.05)

func _typewriter_title(progress: float):
	var full_text = "GAME OVER"
	var visible_chars = int(progress * full_text.length())
	$TitleLabel.visible_characters = visible_chars

func _on_retry():
	get_tree().change_scene_to_file("res://scenes/start_menu.tscn")

func _on_quit():
	get_tree().quit()
