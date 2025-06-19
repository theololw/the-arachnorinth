extends Node2D

# onready nodes
@onready var minimum_node
@onready var maximum_node
@onready var line: Line2D = $Line2D

# variables
@export var constraint_length = 60
var forwards = true

# lists
var positions = []
var relative_positions = []
var directions = []
var final_positions = []
var nodes = []
var minmaxnode = []

func _ready() -> void:
	find_minmax_node()

func _process(delta: float) -> void:
	if forwards == true:

		minimum_node.global_position = get_global_mouse_position()
	else:
		find_minmax_node()
		maximum_node.global_position = get_global_mouse_position()
	
	if Input.is_action_just_pressed("ui_accept"):
		var duplicate = $node1.duplicate()
		add_child(duplicate)
	
	draw_line_from_positions()
	position_nodes()

func position_nodes():
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

func find_minmax_node():
	for node in get_children():
		if node is Node and "node" in node.name.to_lower():
			
			minmaxnode.append(node)
			minimum_node = minmaxnode[0]
			maximum_node = minmaxnode[minmaxnode.size()-1]

func draw_line_from_positions():
	line.clear_points()
	for pos in positions:
		line.add_point(line.to_local(pos))


func _on_h_slider_value_changed(value: float) -> void:
	constraint_length = value

func _on_check_button_toggled(toggled_on: bool) -> void:
	forwards = toggled_on
	find_minmax_node()
