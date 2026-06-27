extends Node2D

var stars: Array[Vector2] = []
var star_speed: float = 50.0
var star_count: int = 200

func _ready():
	for i in range(star_count):
		stars.append(Vector2(randf_range(0, 1280), randf_range(0, 720)))

func _process(delta):
	for i in range(stars.size()):
		stars[i].y += star_speed * delta
		if stars[i].y > 720:
			stars[i] = Vector2(randf_range(0, 1280), 0)
	queue_redraw()

func _draw():
	for star in stars:
		var size = randf_range(1, 3)
		var brightness = randf_range(0.5, 1.0)
		draw_circle(star, size, Color(brightness, brightness, brightness))
