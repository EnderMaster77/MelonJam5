extends Control
@onready var loadingScreen: PackedScene = load("res://Scenes/Menus/LoadingScreen.tscn")
@export var in_level:bool = true
@export var WorldMap: String = "res://Scenes/Menus/MainMenu.tscn"
@onready var MainMenu: String = "res://Scenes/Menus/MainMenu.tscn"
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused == false:
			show()
			get_tree().paused = true
		else:
			hide()
			get_tree().paused = false


func _on_unpause_pressed() -> void:
	hide()
	get_tree().paused = false


func _on_quit_pressed() -> void:
	if in_level == true:
		#Global.sceneToLoadPath = WorldMap
		Global.sceneToLoadPath = MainMenu
		get_tree().paused = false
		get_tree().change_scene_to_packed(loadingScreen)
	else:
		Global.sceneToLoadPath = MainMenu
		get_tree().paused = false
		get_tree().change_scene_to_packed(loadingScreen)

func _on_quit_desktop_pressed() -> void:
	get_tree().quit()
