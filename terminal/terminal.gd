extends Node

signal print_log(statement : String)
signal force_log(statements : Array)
signal terminal_signal(application_id : String, params : Object)

var log : Array
var application: Node
var path = "res://terminal/applications/"

func run_command(command : String):
	add_to_log(command)
	var split_command :	Array
	split_command = command.split(" ")
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
func add_to_log(statement: String):
	log.push_back(statement)
	emit_signal("print_log", statement)
