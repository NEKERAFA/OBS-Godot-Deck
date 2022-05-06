extends Control

const Item = preload("res://scripts/item.gd").Item


enum ObsStatus { NONE, GETTING_SCENES, SCENES_GETTED, FINISHED }


onready var main_grid: Node = $"MainGrid"
onready var item_dialog: Node = $"ItemDialog"
onready var command_form: Node = $"ItemDialog/CommandForm"
onready var message_container: Node = $"MessageContent"
onready var message_background: Node = $"MessageContent/BackgroundRect"
onready var message_lbl: Node = $"MessageContent/MessageLbl"
onready var add_item_btn: Node = $"AddItemBtn"
onready var settings_btn: Node = $"SettingsBtn"


var status = ObsStatus.NONE


func _ready():
	Global.connect_obs()
	command_form.connect("save_item_data", self, "_on_save_item_data")
	add_item_btn.disabled = true
	settings_btn.disabled = true
	message_background.show()
	message_lbl.show()
	message_lbl.text = "Connecting to OBS..."


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
			if message_container.visible:
				message_container.hide()
			
				for item in Global.desktop_items:
					_add_item(item["name"], item["type"], item["value"])
					
		status = ObsStatus.FINISHED


func _on_save_item_data(command_name, command_type, command_value):
	item_dialog.hide()

	Global.desktop_items.append({
		"name": command_name,
		"type": command_type,
		"value": command_value
	})
	
	Global.save_settings()
	
	_add_item(command_name, command_type, command_value)


func _add_item(name, type, value):
	var item = Item.new()
	item.name = name
	item.type = type
	item.value = value
	
	main_grid.add_item(item)


func _remove_item(pos):
	main_grid.remove_item(pos)
