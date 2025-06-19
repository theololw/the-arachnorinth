extends Node2D

var constraint_length = 60
var forwards = true

@onready var minimum_node = $node1
@onready var maximum_node = $node3
@onready var line: Line2D = $Line2D

var foot_position = Vector2(384,360)

var placed_foot = false

var positions = []
var relative_positions = []
var directions = []
var final_positions = []
var nodes = []

func _process(delta: float) -> void:
	draw_line_from_positions()

	position_node_1()

func position_node_1():
	positions = []
	relative_positions = []
	directions = []
	final_positions = []
	nodes = []
	# finding all the nodes and mapping out their id and positions
	for node in get_children():
		if node is Node and "node" in node.name.to_lower():
			nodes.append(node)
			positions.append(node.global_position)

	# work out all the relative positions
	for i in range(positions.size() - 1):
		relative_positions.append(positions[i+1] - positions[i]) 
		directions.append(relative_positions[i].normalized())
		# making the segments look at each other
		if forwards == true:
			nodes[i].look_at(positions[i-1])
		else:
			nodes[i].look_at(positions[i+1])
			
	
	# chaining together the nodes
	
	# one way
	if forwards == true:
		for i in range(nodes.size()-1):
			var ns = nodes.size()
			nodes[(ns-1)-i].global_position = nodes[(ns-2)-i].global_position + (directions[(ns-2)-i] * constraint_length)
		
		#$Node3.position = $Node2.position + (directions[1] * constraint_length)
		#$Node2.position = $Node1.position + (directions[0] * constraint_length)
	
	#the other way
	else:
		for i in range(nodes.size()-1):
			var ns = nodes.size()
			nodes[i].global_position = nodes[i+1].global_position - (directions[i] * constraint_length)
		
		#$Node1.position = $Node2.position - (directions[0] * constraint_length)
		#$Node2.position = $Node3.position - (directions[1] * constraint_length)

# controls the ik of the worm
func _on_timer_timeout() -> void:
	if forwards == false:
		forwards = true
		minimum_node.global_position = foot_position
	else:
		forwards = false
		maximum_node.global_position = $body/leg_anchor.global_position
		
	
	if abs(maximum_node.global_position.distance_to(minimum_node.global_position)) > 120:
		foot_position = $body/foot_placement.global_position

func draw_line_from_positions():
	line.clear_points()
	for pos in positions:
		line.add_point(line.to_local(pos))
