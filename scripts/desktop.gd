extends Control


const InitialConfiguration: PackedScene = preload("res://scenes/InitialConfiguration.tscn")
const MainPanel: PackedScene = preload("res://scenes/MainPanel.tscn")

var initial_configuration: Node = null

var main_panel : Node = null


# Called when the node enters the scene tree for the first time.
func _ready():
	var settings_file = File.new()
	if not settings_file.file_exists(Global.SETTINGS_FILE):
		_add_initial_config_ui()
	else:
		_add_main_ui()


func _add_initial_config_ui():
	initial_configuration = InitialConfiguration.instance()
	$Children.add_child(initial_configuration, true)
	initial_configuration.connect("configuration_saved", self, "_on_configuration_saved")


func _add_main_ui():
	main_panel = MainPanel.instance()
	$Children.add_child(main_panel, true)


func _on_configuration_saved():
	$Children.remove_child(initial_configuration)
	_add_main_ui()
