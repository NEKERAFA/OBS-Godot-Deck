extends VBoxContainer


signal save_item_data(command_name, command_type, command_value)

onready var name_input: LineEdit = $"Name/NameInput"
onready var command_type_opt: OptionButton = $"Option/CommandTypeOpt"
onready var command_value_opt: OptionButton = $"Option/CommandValueOpt"
onready var save_btn: Button = $"SaveBtn"


func _process(delta):
	save_btn.disabled = name_input.text.length() == 0


func _on_SaveBtn_pressed():
	var command_name = name_input.text
	var command_type = command_type_opt.selected
	var command_value = command_value_opt.selected
	
	emit_signal("save_item_data", command_name, command_type, command_value)


func _on_ItemDialog_about_to_show():
	command_type_opt.add_item("Go to scene", 0)
	for scene in Global.obs_scenes:
		command_value_opt.add_item(scene["name"], scene["id"])


func _on_ItemDialog_popup_hide():
	name_input.text = ""
	command_type_opt.selected = -1
	command_type_opt.clear()
	command_value_opt.selected = -1
	command_value_opt.clear()
