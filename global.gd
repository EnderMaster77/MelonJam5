extends Node
class_name global
@export var sceneToLoadPath: String
@export var levelComplete: bool = false
@export var flowShift: bool = false
@export var level1Complete: bool = false
@export var level2Complete: bool = false
@export var level3Complete: bool = false
@export var level4Complete: bool = false
@export var level5Complete: bool = false
@export var level6Complete: bool = false
func save():
	var save_game = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var json_string = JSON.stringify("")
	# Store the save dictionary as a new line in the save file.
	save_game.store_line(json_string)
func load_save():
	pass
