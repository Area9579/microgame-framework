class_name Racecar
extends MicroGame

@onready var track_path: Path2D = $TrackPath
@onready var car_follow: PathFollow2D = $TrackPath/CarFollow
@onready var fail_paths: Array[Path2D] = [
	$FailPaths/FailPath0, $FailPaths/FailPath1,
	$FailPaths/FailPath2, $FailPaths/FailPath3
]
@onready var explosion: AnimatedSprite2D = $TrackPath/CarFollow/Explosion
@onready var qte = $GameUI/QTE
@onready var qte_timer: Timer = $QteTimer
@onready var countdown_label: Label = $GameUI/CountdownLabel
@onready var game_over_panel = $GameUI/GameOverPanel
@onready var game_over_title = $GameUI/GameOverPanel/VBoxContainer/GameOverTitle
@onready var game_over_label = $GameUI/GameOverPanel/VBoxContainer/GameOverLabel


@export var checkpoints: Array[CheckpointData] = []

func _ready() -> void:
	qte_timer.one_shot = true
	explosion.hide()
	run_game()

func run_game() -> void:
	await _run_countdown()

	for i in checkpoints.size():
		var success: bool = await _run_checkpoint(checkpoints[i])
		if not success:
			_handle_fail(i)
			return
			
	_handle_win()

func _run_countdown() -> void:
	countdown_label.show()
	for text in ["3", "2", "1", "Go!"]:
		countdown_label.text = text
		await get_tree().create_timer(0.7).timeout
	countdown_label.hide()

func _run_checkpoint(data: CheckpointData) -> bool:
	# Randomized delay before the QTE triggers
	qte_timer.wait_time = randf_range(data.min_delay, data.max_delay)
	qte_timer.start()
	await qte_timer.timeout

	qte.event_duration = data.qte_duration
	qte.start()
	var success: bool = await qte.finished

	if success:
		var tween := create_tween()
		tween.tween_property(car_follow, "progress_ratio", data.success_ratio, 0.6)
		await tween.finished

	return success

func _handle_fail(checkpoint_index: int) -> void:
	var fail_path := fail_paths[checkpoint_index]

	# Reparent the follow node onto the fail curve
	track_path.remove_child(car_follow)
	fail_path.add_child(car_follow)
	car_follow.progress_ratio = 0.0

	var tween := create_tween()
	tween.tween_property(car_follow, "progress_ratio", 1.0, 0.6)
	await tween.finished

	explosion.show()
	explosion.play("explode") 
	
	await get_tree().create_timer(0.7).timeout
	game_over_panel.visible = true
	game_over_title.text = "CRASHED!"
	game_over_label.text = "Bad news... You're DEAD!"

func _handle_win() -> void:
	await get_tree().create_timer(0.7).timeout
	game_over_panel.visible = true
	game_over_title.text = "SUCCESS!"
	game_over_label.text = "You sure know how to drive!"


func _on_menu_button_pressed():
	pass


func _on_again_button_pressed():
	get_tree().reload_current_scene()
