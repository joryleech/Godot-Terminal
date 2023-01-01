extends TerminalApplication

func _ready():
	name="Test"
	description="Print Test"
	
func run(terminal : Terminal, params : Array):
	terminal.add_to_log("Running Application")
