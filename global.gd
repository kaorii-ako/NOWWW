extends Node

var score: int = 0
var lives: int = 3
var current_minigame: int = 0
var minigames_completed: int = 0
var game_active: bool = false
var total_minigames_to_win: int = 5

var minigame_pool: Array[String] = [
	"res://scenes/minigames/dodge_the_blocks.tscn",
	"res://scenes/minigames/click_the_targets.tscn",
	"res://scenes/minigames/stop_on_green.tscn",
	"res://scenes/minigames/match_the_pattern.tscn",
]
var shuffled_pool: Array[String] = []

signal minigame_won
signal minigame_lost
signal game_over
signal game_won

func reset_game():
	score = 0
	lives = 3
	current_minigame = 0
	minigames_completed = 0
	game_active = true
	shuffled_pool = minigame_pool.duplicate()
	shuffled_pool.shuffle()

func get_next_minigame_path() -> String:
	if current_minigame < shuffled_pool.size():
		return shuffled_pool[current_minigame]
	shuffled_pool.shuffle()
	current_minigame = 0
	return shuffled_pool[0]

func win_minigame():
	minigames_completed += 1
	score += 100
	current_minigame += 1
	minigame_won.emit()
	if minigames_completed >= total_minigames_to_win:
		game_won.emit()

func lose_minigame():
	lives -= 1
	minigame_lost.emit()
	if lives <= 0:
		game_active = false
		game_over.emit()
