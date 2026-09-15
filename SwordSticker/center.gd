extends Node2D

@onready var enemy_amt : int = int(get_parent().difficulty * 10 + 4)

func enemy_died():
	enemy_amt -= 1
	if enemy_amt == 0:
		get_parent().win()

func villager_died():
	get_parent().lose()
