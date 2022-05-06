extends VBoxContainer


signal item_removed(pos)


enum Type { NONE = -1, GO_TO }


class Item:
	var name : String = ""
	var type : int = Type.NONE
	var value: int


var item_position: int = -1
var item_value: Item = null


onready var button: Node = $"Button"
onready var label: Node = $"Label"
onready var timer: Node = $"Timer"


func _ready():
	button.disabled = true


func set_item(position: int, value: Item):
	item_position = position
	item_value = value
	label.text = item_value.name
	button.disabled = false


func remove_item():
	item_position = -1
	item_value = null
	button.disabled = true


func _on_Button_pressed():
	print(item_value.type, Type.GO_TO)
	match item_value.type:
		Type.GO_TO:
			var scene = null
			for scene_item in Global.obs_scenes:
				if scene_item["id"] == item_value.value:
					scene = scene_item
			
			if scene != null:
				Global.send_command("SetCurrentProgramScene", { "sceneName": scene["name"] })


func _on_Button_button_down():
	print("hello")
	if timer.is_stopped():
		timer.start()


func _on_Button_button_up():
	if not timer.is_stopped():
		timer.stop()


func _on_Timer_timeout():
	print("hello 2")
	emit_signal("item_removed", item_position)
