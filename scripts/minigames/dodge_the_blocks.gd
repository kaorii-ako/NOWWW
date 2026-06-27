extends MinigameBase

var player_speed: float = 400.0
var block_speed: float = 200.0
var block_spawn_timer: float = 0.0
var block_spawn_interval: float = 0.5

@onready var player = $Player
@onready var blocks_node = $Blocks

func _on_minigame_start():
	time_limit = 5.0
	instruction_text = "DODGE!"

func _process(delta):
	super._process(delta)
	if not is_active:
		return

	block_spawn_timer += delta
	if block_spawn_timer >= block_spawn_interval:
		block_spawn_timer = 0.0
		_spawn_block()

	_move_player(delta)
	_move_blocks(delta)

func _move_player(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1

	player.position += velocity * player_speed * delta
	player.position.x = clamp(player.position.x, 30, 1250)
	player.position.y = 680

func _spawn_block():
	var block = ColorRect.new()
	block.color = Color(0.9, 0.3, 0.3)
	block.size = Vector2(40, 40)
	block.position = Vector2(randf_range(30, 1250), -40)
	blocks_node.add_child(block)

func _move_blocks(delta):
	for block in blocks_node.get_children():
		block.position.y += block_speed * delta
		if block.position.y > 750:
			block.queue_free()
		elif _check_collision(block):
			lose()

func _check_collision(block: ColorRect) -> bool:
	var player_rect = Rect2(player.position - Vector2(25, 25), Vector2(50, 50))
	var block_rect = Rect2(block.position, block.size)
	return player_rect.intersects(block_rect)
