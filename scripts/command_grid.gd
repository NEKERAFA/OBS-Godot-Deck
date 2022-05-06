extends CenterContainer


const Item = preload("res://scripts/item.gd").Item


var items: Array = []


func add_item(value: Item):
	var size = items.size()
	
	var list_node = get_node("MarginContainer/GridContainer/Item%d" % (size + 1))
	list_node.show()
	list_node.set_item(size, value)
	var err = list_node.connect("item_removed", self, "_on_item_removed")
	if err != OK:
		print(err)
	
	var placeholder = get_node("MarginContainer/GridContainer/PlaceholderItem%d" % (size + 1))
	placeholder.hide()
	
	items.append({
		"node": list_node,
		"placeholder": placeholder
	})


func remove_item(position: int):
	var item = items[position]
	
	var list_node = item["node"] as Node
	list_node.disconnect("item_removed", self, "on_item_removed")
	list_node.remove_item()
	list_node.hide()
	
	var placeholder = item["placeholder"]
	placeholder.show()
	
	items.remove(position)


func _on_item_removed(position: int):
	print(position)
