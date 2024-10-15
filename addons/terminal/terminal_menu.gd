extends Control
signal TerminalMenuToggled

# Called when the node enters the scene tree for the first time.
var renderedLogs : TextEdit
var textInput : TextEdit
var previousMouseMode : Input.MouseMode = Input.MOUSE_MODE_CAPTURED
var scrollContainer : ScrollContainer

@export var menuOpenInputAxis : String 
@export var menuUpAxis : String
@export var menuClearAxis : String
@export var startOpen : bool = true
@export var maxCommandsRemembered : int = 5
var commandsRemembered : Array = []
var commandIndex : int = -1

var open : bool
func _ready():
	Terminal.print_log.connect(_on_terminal_print)
	Terminal.force_log.connect(_on_terminal_force_log)
	textInput = get_node("TerminalInputContainer/TerminalInput")
	renderedLogs = get_node("ScrollContainer/Label")
	scrollContainer = get_node("ScrollContainer")
	scrollContainer.get_v_scroll_bar().changed.connect(_on_terminal_change_size)
	_set_active(startOpen)
	
func _input(event):
	if(event.is_action_pressed(menuOpenInputAxis)):
		_set_active(!open)
	if(open):
		if(event.is_action_pressed(menuClearAxis)):
			textInput.text = ""
			await get_tree().process_frame
			textInput.set_caret_column(len(textInput.text))
		elif(event.is_action_pressed(menuUpAxis)):

				if(commandIndex == -1):
					commandIndex = len(commandsRemembered) - 1
				else:
					commandIndex = commandIndex - 1
				if(commandIndex > -1):
					textInput.text = commandsRemembered[commandIndex]
					await get_tree().process_frame
					textInput.set_caret_column(len(textInput.text))

func _set_active(new_state : bool):
	if(open != new_state):
		emit_signal("TerminalMenuToggled", new_state)
	open = new_state
	visible = new_state
	if(new_state):

		previousMouseMode = Input.mouse_mode
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		await get_tree().process_frame
		textInput.grab_focus() 
	else:
		Input.set_mouse_mode(previousMouseMode)
		

	
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
		remember_command(command.replace("\n",""))
		textInput.text = ""
		commandIndex = -1
		
func remember_command(command):
	commandsRemembered.push_back(command)
	if(len(commandsRemembered) > maxCommandsRemembered):
		commandsRemembered.pop_front()
