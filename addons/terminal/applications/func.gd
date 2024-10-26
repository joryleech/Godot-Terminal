extends TerminalApplication

enum NodeParseType {
	byId,
	byName,
	byType
}

var parseType = NodeParseType.byId

func _init():
	name="Func"
	description="Calls a method on a given node by id"
	
func run(terminal : Terminal, params : Array):
	for param in params.filter(is_flag):
		parse_option(param)
			
	var non_flag_params : Array = params.filter(func(x): return !is_flag(x))
	
	var nodes : Array = []
	
	if non_flag_params.size() < 2:
		terminal.add_to_log("Usage: func [options] <node_id_or_name> <method_name>")
		return

	var node_collection_param : String = non_flag_params[0]
	var method_name : String = non_flag_params[1]

	match(parseType):
		NodeParseType.byId:
			if not node_collection_param.is_valid_int():
				terminal.add_error("Invalid node ID")
				return
			else:
				var node = instance_from_id(int(node_collection_param))
				if(node):
					nodes = [node]
		NodeParseType.byName:
			nodes = Terminal.get_tree().current_scene.find_children(node_collection_param, "", true, false)
		NodeParseType.byType:
			nodes = Terminal.get_tree().current_scene.find_children("*", node_collection_param, true, false)
	if len(nodes) > 0:
		for target_node in nodes:
			if target_node.has_method(method_name):
				var returnValue = target_node.call(method_name)
				terminal.add_to_log("Called method '" + method_name + "' on node " + str(target_node))
				if(returnValue):
					terminal.add_to_log("Returned:"+ str(returnValue) )
				return returnValue
			else:
				terminal.add_error("Method '" + method_name + "' not found on node " + str(target_node))
	else:
		terminal.add_error("Node " + node_collection_param + " not found")
	return -1

func is_flag(param : String) -> bool:
	return param.begins_with("-")

func parse_option(option: String):
	print(option)
	if option == "-t" or option == "--type":
		parseType = NodeParseType.byType
	elif option == "-n" or option == "--name":
		parseType = NodeParseType.byName
