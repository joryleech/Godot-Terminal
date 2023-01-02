class_name TerminalApplication
var name : String = "Application"
var description : String = ""

func run(terminal : Terminal, params : Array):
	terminal.add_to_log("Running Application...")
	
func breakdown_params(params):
	var to_return = []
	for i in range(params.size()):
		var param_breakdown = [params[i], i]
		to_return += [param_breakdown]
	return to_return
