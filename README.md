# Godot-Terminal Plugin
![Capture2](https://github.com/user-attachments/assets/30a48a49-f320-4942-941d-9e821fcca25d)

The **Godot-Terminal** plugin allows developers to add in-game terminals to their projects, giving players access to commands, cheats, and custom in-game programs. Inspired by classic games like **Doom** and **Skyrim**, this plugin provides a flexible, customizable solution for creating immersive game experiences.

## Features

-   **In-Game Terminal**: Add a terminal interface directly into your game.
-   **Custom Command Support**: Developers can create custom programs to run as commands.
-   **Prefab Console**: Includes a prefab console UI for easy integration.
-   **Test Programs**: Several sample programs are provided for testing and extension.
-   **Command Logging**: Tracks player input and displays command logs.
-   **Error Handling**: Basic error reporting for invalid commands.

## Installation

1.  Download or clone this repository into your Godot project under the `addons` folder.
2.  Enable the plugin in the Godot editor by going to `Project > Project Settings > Plugins` and activating **Godot-Terminal**.

## Prefab Usage

### Terminal Setup

Once the plugin is installed, you can add a terminal to your game by using the provided prefab console.

1.  Go to the `addons/terminal` directory.
2.  Drag the terminal_menu prefab into your scene.
3.  In the prefab, set the following variables to Input Mappings
	* Menu Open Input Axis - Toggle the Menu open and close
	* Menu Up Axis - Scroll through history in the input box, to use previous commands easily
	* Menu Clear Axis - Clear current terminal

### Running Commands

The terminal accepts player input as commands. 
To Run a command type the name of the program, then its parameters
**Ex:**
```
command [optional parameter]
> help
> tree -r
```

### Creating Custom Commands

You can extend the terminal functionality by adding your own custom applications:

1.  Place your custom application script in the `addons/terminal/applications/` directory.
2.  Make sure your script has a `run()` method, which will be executed when the command is called.

```gdscript
extends TerminalApplication

func _init():
	name="[REPLACE NAME]"
	description="[REPLACE DESCRIPTION]"
	
func run(terminal : Terminal, params : Array):
	#Code to run
	pass
```

**Params**
* terminal - A reference pointer to the terminal, can be used for seeing previous commands or printing to the terminal
* params - an array of Strings of parameters typed after the program name


# Terminal
The actual terminal is an Autoloaded constant that can be accessed with **Terminal** regardless of the prefab.

### Available Signals

-   **print_log(statement: String)**: Emitted when a new log entry is added.
-   **force_log(statements: Array)**: Emitted when the log is forcefully updated.
-   **terminal_signal(application_id: String, params: Object)**: Emitted when an application is executed.

# Included Applications
### Help
Prints all available applications and their descriptions
### Clear
Clears the console of all previous text
### Quit
Quits the application, not the terminal
### Test
Prints a test script, used as reference
### Tree
Prints the node tree, either from root or given node
**Parameters**
* Node ID - The id of the node to start traversing the tree
* -r - Recursively traverse tree
### Echo
Prints the parameters passed to it
### Func 
Selects and node and runs a function on that node

```
func [options] <node_id_or_name> <method_name>
```
By default the node is selected by ID
the following flags are available:
* -t : Select the node by type, will select all nodes with the type or inherited from type (ex: Node3D, CharacterController3d, or custom types)
* -n : Select node by name

### Set
Sets the variable in the terminal, so that it can be accessed with $ accessor in future command

*Ex:*
```
set variable 1
echo $variable
> 1
```

### Spawn
Find a scene file in the `Res://` folder and spawn it in the current scene

*usage*
```
spawn <SceneFileName> [flags] [flag_options]
```
*Flags:*
* -h : Print the help message
* -s : Search for game object in all files (slow), ex: -s scene_file",
* -f : Choose item by filename ex: -f /scenes/scene_file",
* -p : Select the position the node should be spawned with the following parameters X Y Z",
* -n : Select another node the spawned node should copy the transform of.


## Contribution

Feel free to fork this repository, submit issues, and contribute improvements or additional features.

## License

This project is licensed under the MIT License.
