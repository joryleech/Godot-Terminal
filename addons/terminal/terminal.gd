extends Node

signal print_log(statement : String)
signal force_log(statements : Array)
signal terminal_signal(application_id : String, params : Object)

var log : Array
var application: Node
var path = "res://addons/terminal/applications/"

var settings : Dictionary = {
	
}

var variables = {
	"camid": func(): return str(get_viewport().get_camera_3d().get_instance_id()),
}

func run_command(command : String):
	add_to_log("> " + command)
	
	var split_command :	Array
	var regex_split = RegEx.new()
	regex_split.compile("[^\\s\"']+|\"([^\"]*)\"|'([^']*)'")
	split_command = regex_split.search_all(command).map(func(x): return x.get_string().rstrip("\"").lstrip("\""))
	#Replace variables
	for s_command_index : int in len(split_command):
		var s_command = split_command[s_command_index]
		if(s_command.begins_with("$")):
			print("starts_with $")
			var variable = variables.get(s_command.lstrip("$"), s_command)
			print(variable)
			if(variable is Callable):
				s_command = str(variable.call())
			else:
				s_command = str(variable)
		split_command[s_command_index] = s_command
				
	if(split_command.size() > 0):
		var application = split_command[0]
		var params = split_command.slice(1,split_command.size())
		run_application(application,params)

func clear():
	log = []
	emit_signal("force_log", log)
	
func run_application(application_id, params=[]): 
	var application = find_application(application_id)
	if application != null:
		application.run(self, params)
		pass
	else:
		add_to_log("Application not found")
	
func find_application(application_id):
	if FileAccess.file_exists(path+application_id+".gd"):
		return load(path+application_id+".gd").new()
	else:
		return null

func set_variable(key : String, value : Variant):
	variables[key] = value
	
func get_variable(key : String):
	variables.get(key)

func add_to_log(statement: String):
	log.push_back(statement)
	emit_signal("print_log", statement)
	
func add_error(statement: String):
	add_to_log(statement)
	
func get_setting(key : String, dangerous = false):
	if(dangerous):
		settings.get(key)
	else:	
		if(settings.has(key)):
			return settings.get(key)
			
func set_setting(key : String, value):
	settings[key] = value
