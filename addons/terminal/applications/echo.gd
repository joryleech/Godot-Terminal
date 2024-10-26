extends TerminalApplication

func _init():
	name="Echo"
	description="Write arguments to the standard output"
	
func run(terminal : Terminal, params : Array):
	terminal.add_to_log(
		" ".join(params)
	)
