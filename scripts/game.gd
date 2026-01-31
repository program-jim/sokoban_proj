extends Node2D


func _ready() -> void:
	EventBus.crate_reached_dest.connect(_on_crate_reached_dest)


func _on_crate_reached_dest() -> void:
	for crate: Crate in get_tree().get_nodes_in_group("crates"):
		if not crate.is_reached:
			return
	print("LEVEL COMPLETED !!!")
