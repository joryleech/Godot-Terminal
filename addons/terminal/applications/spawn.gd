extends TerminalApplication

func _init():
	name="Spawn"
	description="spawns a prefab scene"
	
func run(terminal : Terminal, params : Array):
	var flags : Dictionary = get_flags(params)
	if(flags.has("-h")):
		help(terminal)
	else:
		var items : Array[PackedScene] = get_items(terminal, params, flags)
		if(len(items) == 0):
			terminal.add_error("Specified items not found")
			return
		var location = get_transform(terminal, params, flags)
		spawn_item(terminal, items, location)
	
func get_flags(params) -> Dictionary:
	var flags : Dictionary = {}
	for index : int in params.size():
		var param = params[index]
		if(is_parameter_flag(param)):
			flags[param] = {
				"key": param,
				"index": index
			}
	return flags	
	
func get_items(terminal : Terminal, params : Array, flags : Dictionary) -> Array[PackedScene]:
	var available_item_searching_flags : Array = ['-s', '-f']
	var item_grabbing_flags_keys : Array = flags.keys().filter(func(flag): return available_item_searching_flags.has(
		flag
	))
	if(item_grabbing_flags_keys.size() == 0):
		var non_flag_params : Array = params.filter(func(item): return !is_parameter_flag(item))
		if(len(non_flag_params) > 0):
			var to_return : Array[PackedScene]= []
			var item : PackedScene = _get_item_by_search(non_flag_params[0])
			if(!!item):
				to_return.append(item)
			return to_return
		else:
			terminal.add_error("No items flags specified")
			return []
	var items : Array[PackedScene] = []
	for key in item_grabbing_flags_keys:
		var flag_info : Dictionary = flags[key]
		var item = null
		var item_name_index = flags[key]['index']+1
		if(len(params) > item_name_index):
			var item_name : String = params[item_name_index]
			match(key):
				"-s":
					item = _get_item_by_search(item_name)
					pass
				"-f":
					item = _get_item_by_filename(item_name)
			if(item):
				items.append(item)
		else:
			terminal.add_error("File name not provided to flag: "+key)
	return items
	
	pass
	
func _get_item_by_search(item_name : String) -> PackedScene:
	var folders : Array[String] = ["res://"]
	var directory : DirAccess
	for folder in folders:
		directory =  DirAccess.open(folder)
		if(directory.file_exists(item_name+".tscn")):
			return load(folder+item_name+".tscn")
		else:
			folders.append_array(
				Array(directory.get_directories()).filter(func(x): return !x.begins_with(".")).map(func(x): return folder+x+"/")
			)
	return null 
		
func _get_item_by_filename(item_name) -> PackedScene:
	return load("res://"+item_name+".tscn")
	

func get_transform(terminal : Terminal, params : Array, flags : Dictionary):
	var available_item_placing_flags : Array = ['-p','-n']
	var item_placing_flags_keys : Array = flags.keys().filter(func(flag): return available_item_placing_flags.has(
		flag
	))
	var transform : Transform3D
	var item_placing_flags_keys_length = len(item_placing_flags_keys)
	if(item_placing_flags_keys_length > 1):
		terminal.add_error("To many positional flags provided.")
		return transform
	elif(item_placing_flags_keys_length == 1):
		var item_placing_flag_parameter = flags[item_placing_flags_keys[0]]
		match(item_placing_flags_keys[0]):
			"-p":
				var params_after_flag = params.slice(item_placing_flag_parameter['index']+1, item_placing_flag_parameter['index']+4)
				#Validate 3 params after flag are 
				if(len(params_after_flag) < 3):
					terminal.add_error("Not enough positional parameters for -p.")
				elif(params_after_flag.any(is_parameter_flag)):
					terminal.add_error("Not enough positional parameters for -p.")
				elif(params_after_flag.any(func(x): return !x.is_valid_float())):
					terminal.add_error("Positional parameters after -p are not valid")
				else:
					transform.origin.x = float(params_after_flag[0])
					transform.origin.y = float(params_after_flag[1])
					transform.origin.z = float(params_after_flag[2])
				pass
			"-n":
				var params_after_flag = params.slice(item_placing_flag_parameter['index']+1, item_placing_flag_parameter['index']+2)
				if(len(params_after_flag) > 0 && String(params_after_flag[0]).is_valid_int()):
					var node_to_copy = instance_from_id(int(params_after_flag[0]))	
					if(node_to_copy && node_to_copy is Node3D):
						transform = (node_to_copy as Node3D).global_transform
					else:
						terminal.add_error("Transform node not valid selection")
				else:
					terminal.add_error("Positional parameters after -n are not valid")
				
	return transform
	

func spawn_item(terminal : Terminal, items : Array[PackedScene], transform = null):
	for item in items:
		var instanciated_item : Node = item.instantiate()
		if(transform && instanciated_item is Node3D):
			(instanciated_item as Node3D).transform = transform
		terminal.get_tree().current_scene.add_child(instanciated_item)
	
func is_parameter_flag(parameter : String):
	return parameter.begins_with("-")
	
func help(terminal : Terminal):
	var help_message : Array = [
		"-------------------------",
		"SPAWN",
		"-------------------------",
		"usage:",
		"spawn <SceneFileName> [flags]",
		"ex: Spawn SampleScene",
		"",
		"Flags:",
		"-h    : Print the help message",
		"-s    : Search for game object in all files (slow), ex: -s scene_file",
		"-f    : Choose item by filename ex: -f /scenes/scene_file",
		"-p    : Select the position the node should be spawned with the following parameters X Y Z",
		"-n    : Select another node the spawned node should copy the transform of."
	]
	for message in help_message:
		Terminal.add_to_log(message)
