extends Control


const Item = preload("res://scripts/item.gd").Item


signal item_removed(position)


var items: Array = []
var item_to_remove: int = -1


onready var background: Node = $"BackgroundDialog"
onready var dialog_container: Node = $"CenterDialogContainer"
onready var dialog: Node = $"CenterDialogContainer/ConfirmationDialog"


func add_item(value: Item):
	var size = items.size()
	
	var list_node = get_node("CenterContainer/MarginContainer/GridContainer/Item%d" % (size + 1))
	list_node.show()
	list_node.set_item(size + 1, value)
	list_node.connect("item_removed", self, "_on_item_removed")
	
	var placeholder = get_node("CenterContainer/MarginContainer/GridContainer/PlaceholderItem%d" % (size + 1))
	placeholder.hide()
	
	items.append({
		"node": list_node,
		"placeholder": placeholder
	})


func remove_item(position: int):
	var item = items[position]
	
	var list_node = item["node"] as Node
	list_node.disconnect("item_removed", self, "_on_item_removed")
	list_node.remove_item()
	list_node.hide()
	
	var placeholder = item["placeholder"]
	placeholder.show()
	
	items.remove(position)


func clear_item():
	for item in range(items.size()):
		remove_item(0)


func _on_item_removed(position: int):
	item_to_remove = position
	background.show()
	dialog_container.show()
	dialog.popup()


func _on_ConfirmationDialog_confirmed():
	emit_signal("item_removed", item_to_remove)


func _on_ConfirmationDialog_popup_hide():
	background.hide()
	dialog_container.hide()
