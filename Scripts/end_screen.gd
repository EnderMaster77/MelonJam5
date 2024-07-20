extends Control
@onready var loadingScreen: PackedScene = load("res://Scenes/Menus/LoadingScreen.tscn")
@export var in_level:bool = true
@export var WorldMap: String = "res://Scenes/Menus/MainMenu.tscn"
@onready var MainMenu: String = "res://Scenes/Menus/MainMenu.tscn"
func end_game():
	show()
	get_tree().paused = true
	
func _process(delta: float) -> void:
	if Global.levelComplete == true && get_tree().paused == true:
		modulate.a = lerpf(modulate.a, 1, delta *2)

func _on_button_pressed() -> void:
	mark_level_complete($"..".levelNum)
	Global.sceneToLoadPath = MainMenu
	get_tree().paused = false
	Global.levelComplete = false
	get_tree().change_scene_to_packed(loadingScreen)

func mark_level_complete(levelNum: int):
	if levelNum == 1:
		Global.level1Complete = true
	elif levelNum == 2:
		Global.level2Complete = true
	elif levelNum == 3:
		Global.level3Complete = true
	elif levelNum == 4:
		Global.level4Complete = true
	elif levelNum == 5:
		Global.level5Complete = true
	elif levelNum == 6:
		Global.level6Complete = true
