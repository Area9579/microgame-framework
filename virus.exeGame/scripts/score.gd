extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Lose condition
	if Globals.current_terminal_count == 3:
		GameManager.lose()
		# Resets scores
		Globals.current_terminal_count = 0
		Globals.terminals_closed = 0
	
	# Win condition
	if Globals.terminals_closed == 15:
		GameManager.win()
		# Resets scores
		Globals.current_terminal_count = 0
		Globals.terminals_closed = 0
