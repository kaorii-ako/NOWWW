extends Node2D

var stars: Array[Dictionary] = []
var star_speed: float = 50.0
var star_count: int = 200

func _ready():
	for i in range(star_count):
		stars.append({
			"position": Vector2(randf_range(0, 1280), randf_range(0, 720)),
			"size": randf_range(1, 3),
			"brightness": randf_range(0.5, 1.0)
		})

func _process(delta):
	for star in stars:
		star["position"].y += star_speed * delta
		if star["position"].y > 720:
			star["position"] = Vector2(randf_range(0, 1280), 0)
	queue_redraw()

func _draw():
	for star in stars:
		var pos = star["position"]
		var size = star["size"]
		var brightness = star["brightness"]
		draw_circle(pos, size, Color(brightness, brightness, brightness))
