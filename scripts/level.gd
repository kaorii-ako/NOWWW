extends Node2D

var current_minigame_instance: MinigameBase = null
var transition_timer: float = 0.0
var in_transition: bool = false
var is_loading: bool = false

const TRANSITION_DELAY: float = 2.0

@onready var hud = $CanvasLayer/HUD
@onready var lives_label = $CanvasLayer/HUD/LivesLabel
@onready var score_label = $CanvasLayer/HUD/ScoreLabel
@onready var minigame_counter = $CanvasLayer/HUD/MinigameCounter
@onready var get_ready_label = $CanvasLayer/GetReadyLabel

func _ready():
	Global.minigame_won.connect(_on_minigame_won)
	Global.minigame_lost.connect(_on_minigame_lost)
	Global.game_over.connect(_on_game_over)
	Global.game_won.connect(_on_game_won)
	_update_hud()
	get_ready_label.visible = false
	_load_next_minigame()

func _process(delta):
	if in_transition:
		transition_timer -= delta
		if transition_timer <= 0.0:
			in_transition = false
			_load_next_minigame()

func _load_next_minigame():
	if is_loading:
		return
	is_loading = true

	if current_minigame_instance:
		current_minigame_instance.queue_free()
		current_minigame_instance = null

	_show_get_ready()

	await get_tree().create_timer(1.0).timeout

	if not is_inside_tree():
		return

	var path = Global.get_next_minigame_path()
	var scene = load(path) as PackedScene
	current_minigame_instance = scene.instantiate() as MinigameBase
	current_minigame_instance.won.connect(_on_minigame_won_internal)
	current_minigame_instance.lost.connect(_on_minigame_lost_internal)
	add_child(current_minigame_instance)
	is_loading = false

func _on_minigame_won_internal():
	Global.win_minigame()
	_update_hud()

func _on_minigame_lost_internal():
	Global.lose_minigame()
	_update_hud()

func _on_minigame_won():
	_start_transition()

func _on_minigame_lost():
	if Global.game_active:
		_start_transition()

func _start_transition():
	in_transition = true
	transition_timer = TRANSITION_DELAY

func _on_game_over():
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")

func _on_game_won():
	get_tree().change_scene_to_file("res://scenes/winner.tscn")

func _show_get_ready():
	get_ready_label.visible = true
	get_ready_label.modulate.a = 1.0
	var tween = create_tween()
	tween.tween_property(get_ready_label, "modulate:a", 0.0, 0.8).set_delay(0.5)
	tween.tween_callback(func(): get_ready_label.visible = false)

func _update_hud():
	lives_label.text = "Lives: " + str(Global.lives)
	score_label.text = "Score: " + str(Global.score)
	minigame_counter.text = str(Global.minigames_completed) + "/" + str(Global.total_minigames_to_win)
