extends Control

signal show_backdrop_message(message, background)
signal hide_backdrop_message
signal show_backdrop
signal hide_backdrop


onready var backdrop: Node = $"Backdrop"
onready var message_lbl: Node = $"MessageContent/MessageLbl"


func _on_show_backdrop_message(message, background):
	if not visible:
		show()
		
	if background and not backdrop.visible:
		backdrop.show()
	if not background and backdrop.visible:
		backdrop.hide()
	
	if not message_lbl.visible:
		message_lbl.show()
	
	message_lbl.text = str(message)


func _on_hide_backdrop_message():
	if message_lbl.visible:
		message_lbl.hide()


func _on_show_backdrop():
	if not visible:
		show()
	
	if not backdrop.visible:
		backdrop.show()
		
	if message_lbl.visible:
		message_lbl.hide()


func _on_hide_backdrop():
	if backdrop.visible:
		backdrop.hide()
		
