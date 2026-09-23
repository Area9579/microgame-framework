class_name CharacterHandler
extends Node2D

@onready var character_1: AnimatedSprite2D = $Character1
@onready var character_2: AnimatedSprite2D = $Character2
@onready var characters: Array[AnimatedSprite2D] = [
	character_1, character_2]

@export var character_pool: Array[RaceTrackCharacterStats]


## Assigns a sprite to each checkpoint character. Every entry in
## character_pool is guaranteed to appear at least once (as long as there
## are at least that many slots). Any slots left over once the pool is
## exhausted get a random pick from the full pool - repeats allowed there.
func set_character_sprites() -> void:
	if character_pool.is_empty():
		return

	var pool := character_pool.duplicate()
	pool.shuffle()

	for i in characters.size():
		var stats: RaceTrackCharacterStats = (
			pool[i] if i < pool.size() else pool[randi() % pool.size()]
		)
		characters[i].sprite_frames = stats.character_sprite_frames
