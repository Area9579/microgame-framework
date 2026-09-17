class_name Racecar
extends MicroGame

signal game_won
signal game_lost

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
	game_lost.emit()

func _handle_win() -> void:
	game_won.emit()
