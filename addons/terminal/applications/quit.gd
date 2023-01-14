extends TerminalApplication

func _init():
	name="Quit"
	description="Quits the application"
	
func run(terminal : Terminal, params : Array):
	terminal.get_tree().quit()
