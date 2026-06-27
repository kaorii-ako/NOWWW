extends MinigameBase

var indicator_speed: float = 300.0
var indicator_direction: int = 1
var green_zone_start: float = 0.0
var green_zone_width: float = 200.0

@onready var indicator = $Indicator
@onready var green_zone = $GreenZone
@onready var bar = $Bar

func _on_minigame_start():
	time_limit = 4.0
	instruction_text = "STOP!"
	green_zone_start = randf_range(100, 1080)
	green_zone.position.x = green_zone_start
	indicator.position.x = 0

func _process(delta):
	super._process(delta)
	if not is_active:
		return

	indicator.position.x += indicator_speed * indicator_direction * delta
	if indicator.position.x >= 1280:
		indicator_direction = -1
	elif indicator.position.x <= 0:
		indicator_direction = 1

func _input(event):
	if not is_active:
		return

	if event is InputEventKey and event.pressed and event.keycode == KEY_SPACE:
		var indicator_x = indicator.position.x
		if indicator_x >= green_zone_start and indicator_x <= green_zone_start + green_zone_width:
			win()
		else:
			lose()
