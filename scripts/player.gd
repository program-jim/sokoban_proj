extends "res://scripts/game_object.gd"


func _process(delta: float) -> void:
	if tween and tween.is_running():
		return

	var dir := Vector2i(
		Input.get_vector("move_left", "move_right", "move_up", "move_down").round()
	)
	if dir == Vector2i.ZERO:
		return
	if dir.x != 0:
		dir.y = 0

	var dest := cell_position + dir
	if is_wall(dest):
		bump(dest)
		return

	var crate := get_crate(dest)
	if crate:
		var crate_dest := dest + dir
		if is_wall(crate_dest) or get_crate(crate_dest):
			bump(dest)
			return
		crate.move_to(crate_dest)

	move_to(dest)
