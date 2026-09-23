class_name RacecarLevel0
extends MicroGame

@onready var character_handler = $CharacterHandler
@onready var explosion = %Explosion
@onready var track_path: Path2D = $TrackPath
@onready var car_follow: PathFollow2D = $TrackPath/CarFollow
@onready var fail_paths: Array[Path2D] = [
	$FailPaths/FailPath0, $FailPaths/FailPath1,
]
@onready var qte = $GameUI/QTE
@onready var qte_timer: Timer = $QteTimer
@onready var countdown_label: Label = $GameUI/CountdownLabel
@onready var game_over_panel = $GameUI/GameOverPanel
@onready var game_over_title = $GameUI/GameOverPanel/VBoxContainer/GameOverTitle
@onready var game_over_label = $GameUI/GameOverPanel/VBoxContainer/GameOverLabel
@onready var racecar = $TrackPath/CarFollow/Racecar

@export var racetrack_stats: RacetrackLevelStats

var _waiting_for_qte := false
var _false_started := false


func _ready() -> void:
	await character_handler.set_character_sprites()
	qte_timer.one_shot = true
	run_game()

func _input(event: InputEvent) -> void:
	if not _waiting_for_qte:
		return
	if event is InputEventKey and event.pressed and not event.is_echo() and event.keycode == KEY_SPACE:
		_waiting_for_qte = false
		_false_started = true
		qte_timer.stop()
		qte_timer.timeout.emit()

func run_game() -> void:
	await _run_countdown()

	for i in racetrack_stats.checkpoints.size():
		var success: bool = await _run_checkpoint(racetrack_stats.checkpoints[i])
		if not success:
			_handle_fail(i, _false_started)
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
	_false_started = false
	_waiting_for_qte = true

	qte_timer.wait_time = randf_range(racetrack_stats.min_delay, racetrack_stats.max_delay)
	qte_timer.start()
	await qte_timer.timeout

	_waiting_for_qte = false
	if _false_started:
		return false

	qte.event_duration = data.qte_duration
	qte.start()
	var success: bool = await qte.finished

	if success:
		var tween := create_tween()
		tween.tween_property(car_follow, "progress_ratio", data.success_ratio, 0.6)\
			.set_trans(Tween.TRANS_SINE)\
			.set_ease(Tween.EASE_IN_OUT)
		await tween.finished

	return success

func _handle_fail(checkpoint_index: int, false_start := false) -> void:
	var fail_path := fail_paths[checkpoint_index]
	
	# Reparent the follow node onto the fail curve
	track_path.remove_child(car_follow)
	fail_path.add_child(car_follow)
	car_follow.progress_ratio = 0.0
	
	character_handler.get_child(checkpoint_index).play("death")
	var tween := create_tween()
	tween.tween_property(car_follow, "progress_ratio", 1.0, 0.6)
	await tween.finished
	
	explosion.play("explode")
	racecar.queue_free()
	character_handler.get_child(checkpoint_index).queue_free()
	
	
	await get_tree().create_timer(0.7).timeout
	game_over_panel.visible = true
	game_over_title.text = "CRASHED!"
	game_over_label.text = "TOO EARLY, BUCKO!" if false_start else "Bad news... You're DEAD!"


func _handle_win() -> void:
	await get_tree().create_timer(0.7).timeout
	game_over_panel.visible = true
	game_over_title.text = "SUCCESS!"
	game_over_label.text = "You sure know how to drive!"


func _handle_false_start() -> void:
	qte.queue_free()
	explosion.play("explode")
	racecar.queue_free()
	game_over_panel.visible = true
	game_over_title.text = "FALSE START!"
	game_over_label.text = "TOO EARLY, BUCKO!"

func _on_menu_button_pressed():
	pass


func _on_again_button_pressed():
	get_tree().reload_current_scene()
