extends MinigameBase

var pattern: Array[int] = []
var clicked_tiles: Array[int] = []
var pattern_size: int = 3
var grid_buttons: Array[Button] = []

@onready var grid = $GridContainer
@onready var pattern_display = $PatternDisplay

func _on_minigame_start():
	time_limit = 6.0
	instruction_text = "MATCH!"
	_setup_grid()
	_generate_pattern()
	_show_pattern()

func _setup_grid():
	grid.columns = 3
	var colors = [
		Color(1.0, 0.2, 0.3),
		Color(0.2, 0.6, 1.0),
		Color(0.0, 1.0, 0.5),
		Color(1.0, 0.8, 0.0),
		Color(0.8, 0.2, 1.0),
		Color(1.0, 0.5, 0.0),
		Color(0.0, 1.0, 1.0),
		Color(1.0, 0.4, 0.7),
		Color(0.5, 1.0, 0.5)
	]
	for i in range(9):
		var button = Button.new()
		button.custom_minimum_size = Vector2(100, 100)
		button.text = str(i + 1)
		button.modulate = colors[i]
		button.pressed.connect(_on_tile_pressed.bind(i))
		grid.add_child(button)
		grid_buttons.append(button)

func _generate_pattern():
	pattern.clear()
	while pattern.size() < pattern_size:
		var num = randi() % 9
		if num not in pattern:
			pattern.append(num)

func _show_pattern():
	pattern_display.text = "Remember: " + str(pattern)
	await get_tree().create_timer(2.0).timeout
	pattern_display.text = "Your turn!"

func _on_tile_pressed(tile_index: int):
	if not is_active:
		return

	if tile_index in pattern and tile_index not in clicked_tiles:
		clicked_tiles.append(tile_index)
		grid_buttons[tile_index].modulate = Color(0.3, 0.9, 0.3)

		if clicked_tiles.size() == pattern_size:
			win()
	else:
		grid_buttons[tile_index].modulate = Color(0.9, 0.2, 0.2)
		lose()
