extends TerminalApplication

func _init():
	name="Test"
	description="Print Test"
	
func run(terminal : Terminal, params : Array):
	terminal.add_to_log("Running Application")
