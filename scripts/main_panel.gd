extends Control

const Item = preload("res://scripts/item.gd").Item


enum ObsStatus { NONE, GETTING_SCENES, SCENES_GETTED, FINISHED }


onready var main_grid: Node = $"MainGrid"
onready var item_dialog: Node = $"ItemDialog"
onready var command_form: Node = $"ItemDialog/CommandForm"
onready var message_container: Node = $"MessageContent"
onready var message_background: Node = $"MessageContent/BackgroundRect"
onready var message_lbl: Node = $"MessageContent/MessageLbl"
onready var settings_panel: Node = $"SettingsPanel"
onready var add_item_btn: Node = $"AddItemBtn"
onready var settings_btn: Node = $"SettingsBtn"


var status = ObsStatus.NONE


func _ready():
	command_form.connect("save_item_data", self, "_on_ItemDialog_save_data")
	add_item_btn.disabled = true
	message_background.show()
	message_lbl.show()
	message_lbl.text = "Connecting to OBS..."
	Global.connect_obs()
	
	for item in Global.desktop_items:
		_add_item(item["name"], item["type"], item["value"])


func _process(delta):
	if status == ObsStatus.NONE and Global.obs_connected:
		message_lbl.text = "Getting scenes..."
		Global.send_command("GetSceneList")
		status = ObsStatus.GETTING_SCENES
		
	if status == ObsStatus.GETTING_SCENES and Global.obs_scenes_getted:
		status = ObsStatus.SCENES_GETTED
	
	if status == ObsStatus.SCENES_GETTED and Global.obs_scenes.size() > 0:
		if message_background.visible:
			message_background.hide()
			
			add_item_btn.disabled = false
			settings_btn.disabled = false

		if Global.desktop_items.size() == 0:
			message_lbl.text = "Add commands to show there"
		else:
			message_lbl.hide()
			message_container.hide()
			
		status = ObsStatus.FINISHED


func _add_item(name, type, value):
	var item = Item.new()
	item.name = name
	item.type = type
	item.value = value
	 
	main_grid.add_item(item)


func _remove_item(pos):
	main_grid.remove_item(pos)


func _clear_items():
	main_grid.clear_item()


func _on_item_removed(position):
	_remove_item(position)
	
	Global.desktop_items.remove(position)
	Global.save_settings()
	
	if Global.desktop_items.size() == 0:
		message_container.show()
		message_lbl.show()
		message_lbl.text = "Add commands to show there"


func _on_AddItemBtn_pressed():
	message_container.show()
	message_background.show()
	item_dialog.window_title = "Add Command"
	item_dialog.popup_centered()


func _on_ItemDialog_popup_hide():
	message_background.hide()
	if Global.desktop_items.size() > 0:
		message_container.hide()


func _on_ItemDialog_save_data(command_name, command_type, command_value):
	item_dialog.hide()

	Global.desktop_items.append({
		"name": command_name,
		"type": command_type,
		"value": command_value
	})
	
	Global.save_settings()
	
	_add_item(command_name, command_type, command_value)
	
	if message_lbl.visible:
		message_lbl.hide()
	
	if message_container.visible:
		message_container.hide()


func _on_SettingsBtn_pressed():
	message_container.show()
	message_background.show()
	settings_panel.show()


func _on_SettingsPanel_close_pressed():
	message_background.hide()
	if Global.desktop_items.size() > 0:
		message_container.hide()


func _on_SettingsPanel_settings_saved():
	add_item_btn.disabled = true
	
	message_background.show()
	message_lbl.show()
	message_lbl.text = "Connecting to OBS..."
	
	Global.connect_obs()
	
	status = ObsStatus.NONE
	
	_clear_items()
	for item in Global.desktop_items:
		_add_item(item["name"], item["type"], item["value"])
