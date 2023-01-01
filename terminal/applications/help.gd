extends TerminalApplication

func _init():
	name="Help"
	description="Shows descriptions of all available programs"
	
func run(terminal : Terminal, params : Array):
	var files = DirAccess.get_files_at(terminal.path)
	if("verbose" in params):
		for file in files:
			if(".gd" in file):
				var application = load(terminal.path+file).new()
				var help_text = application.name + " - " + application.description
				terminal.add_to_log(help_text)
	else:
		for file in files:
			if(".gd" in file):
				terminal.add_to_log(file.replace(".gd",""))
