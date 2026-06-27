extends Control

func _ready():
	$ScoreLabel.text = "SCORE: %d" % Global.score
	_animate_entrance()
	$PlayAgainButton.pressed.connect(_on_play_again)
	$QuitButton.pressed.connect(_on_quit)

func _animate_entrance():
	$TitleLabel.scale = Vector2.ZERO
	var tween = create_tween()
	tween.tween_property($TitleLabel, "scale", Vector2.ONE, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_method(_update_score_display, 0, Global.score, 1.0)

func _update_score_display(val: int):
	$ScoreLabel.text = "SCORE: %d" % val

func _on_play_again():
	get_tree().change_scene_to_file("res://scenes/start_menu.tscn")

func _on_quit():
	get_tree().quit()
