extends Node

@onready var tile_map_layer: TileMapLayer = $"../TileMapLayer"

const FARM_TILE_ID: int = 4 # The ID 0of the farm tile

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		# Get the global mouse position
		var mouse_position = get_viewport().get_mouse_position()

		# Convert the global mouse position to local position in the TileMapLayer
		var local_position = tile_map_layer.to_local(mouse_position)

		# Convert local position to map coordinates
		var tile_position: Vector2i = tile_map_layer.local_to_map(local_position)
		
		tile_map_layer.set_cell(tile_position, FARM_TILE_ID, Vector2i(0, 5), 0)

		# Force an update to ensure changes are rendered
		tile_map_layer.update_internals()
