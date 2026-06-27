class_name MinigameBase
extends Node2D

@export var time_limit: float = 5.0
@export var instruction_text: String = "DO THE THING!"

var time_remaining: float = 0.0
var is_active: bool = false
var timer_label: Label = null

signal won
signal lost

func _ready():
	time_remaining = time_limit
	is_active = true
	_create_timer_display()
	_show_instruction()
	_on_minigame_start()

func _process(delta):
	if not is_active:
		return
	time_remaining -= delta
	_update_timer_display()
	if time_remaining <= 0.0:
		_on_timeout()

func _on_minigame_start():
	pass

func win():
	if not is_active:
		return
	is_active = false
	won.emit()

func lose():
	if not is_active:
		return
	is_active = false
	lost.emit()

func _on_timeout():
	lose()

func _create_timer_display():
	timer_label = Label.new()
	timer_label.text = "%.1f" % time_remaining
	timer_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	timer_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	timer_label.add_theme_font_size_override("font_size", 36)
	timer_label.modulate = Color(1, 1, 0, 1)
	timer_label.position = Vector2(1180, 10)
	timer_label.size = Vector2(90, 50)
	add_child(timer_label)

func _update_timer_display():
	if timer_label:
		timer_label.text = "%.1f" % max(0, time_remaining)
		var ratio = time_remaining / time_limit
		if ratio > 0.5:
			timer_label.modulate = Color(0, 1, 0, 1)
		elif ratio > 0.25:
			timer_label.modulate = Color(1, 1, 0, 1)
		else:
			timer_label.modulate = Color(1, 0, 0, 1)

func _show_instruction():
	var label = Label.new()
	label.text = instruction_text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 48)
	label.modulate = Color(1, 1, 1, 1)
	label.position = Vector2(540, 300)
	label.size = Vector2(200, 60)
	add_child(label)
	var tween = create_tween()
	tween.tween_property(label, "modulate:a", 0.0, 1.5).set_delay(0.5)
	tween.tween_callback(label.queue_free)
