extends Node


const ObsWebSocket: GDScript = preload('res://addons/obs-websocket-gd/obs_websocket.gd')
const SETTINGS_FILE: String = "user://obs_deck.cfg"

var obs_websocket: Node

var obs_settings: Dictionary = {
		"host": "localhost",
		"password": "1234",
}


func _ready():
	var settings_file = File.new()
	
	if settings_file.file_exists(SETTINGS_FILE):
		settings_file = ConfigFile.new()
		
		if settings_file.load(SETTINGS_FILE) != OK:
			return
		
		obs_settings["host"] = settings_file.get_value("ObsWebSocket", "host")
		if settings_file.has_section_key("ObsWebSocket", "port"):
			obs_settings["port"] = settings_file.get_value("ObsWebSocket", "port")
		obs_settings["password"] = settings_file.get_value("ObsWebSocket", "password")


func connect_obs():
	obs_websocket = ObsWebSocket.new()
	obs_websocket.host = obs_settings["host"]
	if obs_settings.has("port"):
		obs_websocket.port = obs_settings["port"]
	obs_websocket.password = obs_settings["password"]

	add_child(obs_websocket, true)
	
	obs_websocket.connect("obs_data_received", self, "_on_obs_data_received")
	
	if obs_websocket.establish_connection() != OK:
		push_error("Cannot connect with OBS")
	
	yield(obs_websocket, "obs_authenticated")
	
	obs_websocket.send_command("GetVersion")


func update_settings():
	var settings_file = ConfigFile.new() 
	var err = settings_file.load(SETTINGS_FILE)
	if err != OK:
		return err
	
	obs_settings["host"] = settings_file.get_value("obs", "host")
	if settings_file.has_section_key("obs", "port"):
		obs_settings["port"] = settings_file.get_value("obs", "port")
	obs_settings["password"] = settings_file.get_value("obs", "password")


func save_settings():
	var settings_file = ConfigFile.new()
	
	settings_file.set_value("ObsWebSocket", "host", obs_settings["host"])
	if obs_settings.has("port"):
		settings_file.set_value("ObsWebSocket", "port", obs_settings["port"])
	settings_file.set_value("ObsWebSocket", "password", obs_settings["password"])
	
	settings_file.save(SETTINGS_FILE)


func _on_obs_data_received(data):
	print(data.get_as_json())
