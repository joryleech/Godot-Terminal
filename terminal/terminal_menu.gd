extends Control


# Called when the node enters the scene tree for the first time.
var renderedLogs : TextEdit
var textInput : TextEdit
var scrollContainer : ScrollContainer
func _ready():
	Terminal.print_log.connect(_on_terminal_print)
	Terminal.force_log.connect(_on_terminal_force_log)
	textInput = get_node("TerminalInputContainer/TerminalInput")
	renderedLogs = get_node("ScrollContainer/Label")
	scrollContainer = get_node("ScrollContainer")
	scrollContainer.get_v_scroll_bar().changed.connect(_on_terminal_change_size)
	

func _on_terminal_change_size():
	scrollContainer.scroll_vertical = scrollContainer.get_v_scroll_bar().max_value
	
func _on_terminal_print(statement):
	renderedLogs.text = renderedLogs.text+"\n"+statement
	pass
	
func _on_terminal_force_log(log):
	var new_log_text = ""
	for statement in log:
		new_log_text += statement +"\n"
	renderedLogs.text = new_log_text

func _on_text_edit_text_changed():
	var command = textInput.text
	if '\n' in command:
		Terminal.run_command(command.replace("\n",""))
		textInput.text = ""
