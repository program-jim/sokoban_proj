extends "res://scripts/game_object.gd"

var astar := AStarGrid2D.new()
var nav_path: Array[Vector2i]


func _ready() -> void:
	astar.region = map.get_used_rect()
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER # No Diagon
	astar.update()

	for cell in map.get_used_cells():
		if is_wall(cell):
			astar.set_point_solid(cell)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("nav"):
		var dest := map.local_to_map(map.to_local(get_global_mouse_position()))
		if not is_wall(dest):
			astar.fill_weight_scale_region(astar.region, 1)
			for crate: Crate in get_tree().get_nodes_in_group("crates"):
				astar.set_point_weight_scale(crate.cell_position, 8)
			nav_path = astar.get_id_path(cell_position, dest)
			if nav_path:
				nav_path.remove_at(0)

	if tween and tween.is_running():
		return

	if nav_path:
		var next := nav_path.pop_front() as Vector2i
		if not try_move(next - cell_position):
			nav_path.clear()
		return

	var dir := Vector2i(
		Input.get_vector("move_left", "move_right", "move_up", "move_down").round()
	)
	if dir == Vector2i.ZERO:
		return
	if dir.x != 0:
		dir.y = 0
	try_move(dir)


## Try to move according to given direction.
func try_move(dir: Vector2i) -> bool:
	var dest := cell_position + dir
	if is_wall(dest):
		bump(dest)
		return false

	var crate := get_crate(dest)
	if crate:
		var crate_dest := dest + dir
		if is_wall(crate_dest) or get_crate(crate_dest):
			bump(dest)
			return false
		crate.move_to(crate_dest)

	move_to(dest)
	return true
