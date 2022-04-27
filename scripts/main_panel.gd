extends Control


func _ready():
	Global.connect_obs()
	$"ItemDialog/CommandForm".connect("save_item_data", self, "_on_save_item_data")


func _on_save_item_data(command_name, command_type, command_value):
	$"ItemDialog".hide()
	print(command_name, ', ', command_type, ', ', command_value)
