extends Panel


onready var address_input = $"Data/Content/Form/Items/Data/AddressData/AddressInput"
onready var port_input = $"Data/Content/Form/Items/Data/AddressData/PortInput"
onready var password_input = $"Data/Content/Form/Items/Data/PasswordInput"
onready var save_btn = $"Data/Content/Form/Items/SaveBtn"


func _process(_delta):
	save_btn.disabled = address_input.text.length() == 0 or password_input.text.length() == 0
	
	if save_btn.disabled:
		save_btn.focus_mode = Control.FOCUS_NONE
		password_input.focus_neighbour_bottom = "Data/Content/Form/Items/SaveBtn"
		password_input.focus_next = "Data/Content/Form/Items/SaveBtn"
	else:
		save_btn.focus_mode = Control.FOCUS_ALL
		password_input.focus_neighbour_bottom = ""
		password_input.focus_next = ""


func _on_SaveBtn_pressed():
	Global.obs_settings["host"] = address_input.text
	
	if port_input.text.length() > 0:
		Global.obs_settings["port"] = port_input.text
		
	Global.obs_settings["password"] = password_input.text
	
	Global.save_settings()
	
	get_tree().change_scene("res://scenes/MainPanel.tscn")
