extends TerminalApplication

func _ready():
	name="Clear"
	description="Clears the log"
	
func run(terminal : Terminal, params : Array):
	terminal.clear()
