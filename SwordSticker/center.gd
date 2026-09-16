extends Node2D

@onready var enemy_amt : int = int(get_parent().difficulty * 5 + 4)

func enemy_died():
	get_parent().increase_count()
	enemy_amt -= 1
	if enemy_amt == 0:
		get_parent().win()

func villager_died():
	get_parent().decrease_count()
