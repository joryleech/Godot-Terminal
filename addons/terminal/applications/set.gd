extends TerminalApplication

func _init():
	name="Set"
	description="Sets a variable in the terminal"
	
func run(terminal : Terminal, params : Array):
	if(len(params) < 2):
		terminal.add_to_log("Usage: set <variable_name> <value>")
		return
	terminal.set_variable(params[0], params[1])
