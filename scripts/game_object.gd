extends Node2D

var tween: Tween

@export var tween_duration: float = 0.2

@onready var map: TileMapLayer = get_parent()
@onready var cell_position: Vector2i = map.local_to_map(position)


## Move to given cell position.
func move_to(cell: Vector2i) -> void:
	cell_position = cell
	#position = map.map_to_local(cell) # Transform directly

	# Use Tween instead
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position", map.map_to_local(cell), tween_duration)


## Bump animation
func bump(cell: Vector2i) -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position", (map.map_to_local(cell) + position) / 2, tween_duration)
	tween.tween_property(self, "position", position, tween_duration)


## Get crate according to given cell vector.
func get_crate(cell: Vector2i) -> Crate:
	for crate: Crate in get_tree().get_nodes_in_group("crates"):
		if crate.cell_position == cell:
			return crate
	return null


## Wall detection
func is_wall(cell: Vector2i) -> bool:
	var data := map.get_cell_tile_data(cell)
	if not data:
		return false
	return data.get_custom_data("is_wall")


## Destination detection
func is_dest(cell: Vector2i) -> bool:
	var data := map.get_cell_tile_data(cell)
	if not data:
		return false
	return data.get_custom_data("is_dest")
