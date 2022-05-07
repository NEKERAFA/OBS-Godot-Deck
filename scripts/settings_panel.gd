extends PanelContainer


signal close_pressed
signal settings_saved


var reset_grid: bool = false


onready var address_input: Node = $"ScrollContainer/VBoxContainer/ObsWebsocket/ObsWebSocketForm/AddressData/AddressInput"
onready var port_input: Node = $"ScrollContainer/VBoxContainer/ObsWebsocket/ObsWebSocketForm/AddressData/PortInput"
onready var password_input: Node = $"ScrollContainer/VBoxContainer/ObsWebsocket/ObsWebSocketForm/PasswordInput"


func _on_ReturnBtn_pressed():
	hide()
	emit_signal("close_pressed")


func _on_SaveBtn_pressed():
	Global.obs_settings["host"] = address_input.text
	if port_input.text.length() > 0:
		Global.obs_settings["port"] = port_input.text
	Global.obs_settings["password"] = password_input.text
	
	if reset_grid:
		Global.desktop_items.clear()
		
	Global.save_settings()
	
	hide()
	emit_signal("settings_saved")


func _on_SettingsPanel_draw():
	address_input.text = Global.obs_settings["host"]
	if Global.obs_settings.has("port"):
		port_input.text = Global.obs_settings["port"]
	password_input.text = Global.obs_settings["password"]
	
	reset_grid = false


func _on_ResetGridBtn_pressed():
	reset_grid = true
