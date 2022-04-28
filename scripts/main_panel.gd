extends Control

enum ObsStatus { None, GettingScenes, ScenesGetted }

onready var message_background: Node = $"MessageContent/BackgroundRect"
onready var message_lbl: Node = $"MessageContent/MessageLbl"

var status = ObsStatus.None


func _ready():
	Global.connect_obs()
	$"ItemDialog/CommandForm".connect("save_item_data", self, "_on_save_item_data")
	message_background.show()
	message_lbl.show()
	message_lbl.text = "Connecting to OBS..."


func _process(delta):
	if Global.obs_connected and status == ObsStatus.None:
		message_lbl.text = "Getting scenes..."
		Global.send_command("GetSceneList")
		status = ObsStatus.GettingScenes
	
	if Global.obs_scenes.size() > 0:
		message_background.hide()
		if Global.desktop_items.size() == 0:
			message_lbl.text = "Add commands to show there"
		else:
			message_lbl.hide()


func _on_save_item_data(command_name, command_type, command_value):
	$"ItemDialog".hide()
	print(command_name, ', ', command_type, ', ', command_value)
