extends Control

@onready var tile_map_layer: TileMapLayer = $"../TileMapLayer"

@onready var player: Node2D = $"../Player"


const FARM_TILE_ID: int = 4 # The ID of the farm tile

const FARM_GROWTH_TILES = [Vector2i(1, 5), Vector2i(2, 5), Vector2i(0, 6), Vector2i(1,6), Vector2i(2, 6)] 

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var mouse_position = get_global_mouse_position()
		
		if player._check_can_move():
			return
		else:
			# Convert the global mouse position to local position in the TileMapLayer
			var local_position = tile_map_layer.to_local(mouse_position)

			# Convert local position to map coordinates
			var tile_position: Vector2i = tile_map_layer.local_to_map(local_position)
		
			var source_id = tile_map_layer.get_cell_source_id(tile_position)
			print("Tile source ID at position ", tile_position, ": ", source_id)
		
			tile_map_layer.set_cell(tile_position, FARM_TILE_ID, Vector2i(0, 5), 0)

			growTile(tile_position)
		
			# Force an update to ensure changes are rendered
			tile_map_layer.update_internals()
		
func growTile(new_tile_position:Vector2i):
	for Tile in FARM_GROWTH_TILES:
		await get_tree().create_timer(2).timeout
		tile_map_layer.set_cell(new_tile_position, FARM_TILE_ID, Tile)
	

func _is_Valid_tile(check_pos: Vector2) -> bool:
			# Convert the global mouse position to local position in the TileMapLayer
			var local_position = tile_map_layer.to_local(check_pos)

			# Convert local position to map coordinates
			var tile_position: Vector2i = tile_map_layer.local_to_map(local_position)
		
			var source_coords = tile_map_layer.get_cell_atlas_coords(tile_position)
			
			if source_coords == Vector2i(0, 0):
				print("Can move on tile")
				return true
			else:
				print("CANNOT MOVE HERE")
				return false
	
