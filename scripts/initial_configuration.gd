extends CenterContainer


signal configuration_saved

onready var address_input = $"Content/Form/Items/ObsWebSocketForm/AddressData/AddressInput"
onready var port_input = $"Content/Form/Items/ObsWebSocketForm/AddressData/PortInput"
onready var password_input = $"Content/Form/Items/ObsWebSocketForm/PasswordInput"
onready var save_btn = $"Content/Form/Items/SaveBtn"


func _process(_delta):
	save_btn.disabled = address_input.text.length() == 0 or password_input.text.length() == 0
	
	if save_btn.disabled:
		save_btn.focus_mode = Control.FOCUS_NONE
		password_input.focus_neighbour_bottom = "Content/Form/Items/SaveBtn"
		password_input.focus_next = "Content/Form/Items/SaveBtn"
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
	
	emit_signal("configuration_saved")
