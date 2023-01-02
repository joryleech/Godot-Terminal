extends TerminalApplication

var max_depth = 10000
var _terminal : Terminal
func _init():
	name="Tree"
	description="Shows the node tree"
	
func run(terminal : Terminal, params : Array):
	_terminal = terminal
	var root_node = _terminal.get_tree().get_current_scene()
	print(root_node)
	print("Test")
	draw_branch(root_node, 0, params)
	
func draw_branch(node : Node, depth : int, params : Array):
	draw_node(node, depth, params)
	if depth < max_depth && is_recursive(params):
		for _child in node.get_children():
			draw_branch(_child, depth + 1, params)
	
func draw_node(node : Node, depth : int, params : Array):
	_terminal.add_to_log(
		generate_depth_signifier(depth,params)+node.to_string()
	)
	
func generate_depth_signifier(depth, params):
	var string = ""
	for i in range(depth):
		string += self.get_depth_delimiter()
	return string
	
func get_depth_delimiter():
	return "    "
	
func is_recursive(params):
	#TODO CACHE
	var recursive_tags = ['-r']
	for param in params:
		if param.to_lower() in recursive_tags:
			return true
	return false
