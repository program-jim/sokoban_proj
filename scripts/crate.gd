class_name Crate
extends "res://scripts/game_object.gd"

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_reached: bool = false:
	set(value):
		if is_reached == value:
			return
		is_reached = value
		animation_player.play("reached" if is_reached else "default")
		if is_reached:
			EventBus.crate_reached_dest.emit()


## Move to given cell position.
func move_to(cell: Vector2i) -> void:
	super(cell)
	is_reached = is_dest(cell)
