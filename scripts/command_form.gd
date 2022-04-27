extends VBoxContainer


signal save_item_data(command_name, command_type, command_value)

onready var name_input = $"Name/NameInput"
onready var command_type_opt = $"Option/CommandTypeOpt"
onready var command_value_opt = $"Option/CommandValueOpt"
onready var save_btn = $"SaveBtn"

func _ready():
	command_type_opt.add_item("Go to scene", 0)
#	command_value_opt.add_item("Scene", 1)

func _process(delta):
	save_btn.disabled = name_input.text.length() == 0


func _on_SaveBtn_pressed():
	var command_name = name_input.text
	var command_type = command_type_opt.selected
	var command_value = command_value_opt.selected
	
	name_input.text = ""
	command_type_opt.selected = -1
	command_value_opt.selected = -1
	
	emit_signal("save_item_data", command_name, command_type, command_value)
