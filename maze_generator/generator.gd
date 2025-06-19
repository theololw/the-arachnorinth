extends Sprite2D

@export var maze_size: Vector2i = Vector2i(31, 25) # Must be odd numbers

var maze_pos = Vector2i(0, 0) # start position for the generator
var dir_history = []
var directions = [Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT]

var tile_n = Vector2i(0, 0) # not visited        # dark blue
var tile_v = Vector2i(0, 1) # visited            # light blue
var tile_s = Vector2i(1, 1) # visited and stuck  # blue

signal done

@onready var Maze = $"../maze"

func _ready() -> void:
	Maze.clear()
	# Initialize all cells as unvisited
	for y in range(maze_size.y):
		for x in range(maze_size.x):
			Maze.set_cell(Vector2i(x, y), 0, tile_n)
	
	# Start position
	maze_pos = Vector2i(1, 1)
	Maze.set_cell(maze_pos, 0, tile_v)

func get_neighbors():
	"Get surrounding not visited neighbors"
	var dlist = []
	for dir in directions:
		var next_pos = maze_pos + dir * 2
		if Maze.get_cell_atlas_coords(next_pos) == tile_n:
			dlist.append(dir)
	return dlist

func _process(delta: float) -> void:
	var dlist = get_neighbors() # possible directions list
	
	if dlist.is_empty():
		if dir_history.is_empty():
			print("Maze generation completed")
			done.emit()
			set_process(false)
			return
		
		# Remove current cell in history if stuck and go back
		var removed_item = dir_history.pop_back()
		Maze.set_cell(maze_pos - removed_item, 0, tile_s)
		Maze.set_cell(maze_pos, 0, tile_s)
		maze_pos = maze_pos - removed_item * 2
		
	else:
		# Pick random neighbor
		var dir = dlist.pick_random()
		
		# Remove wall between current and next cell
		Maze.set_cell(maze_pos + dir, 0, tile_v)
		
		# Add direction to history
		dir_history.append(dir)
		
		# Move to new cell
		maze_pos += dir * 2
		Maze.set_cell(maze_pos, 0, tile_v)
	
	# Update sprite position
	position = 16 * maze_pos + Vector2i(1, 1)
