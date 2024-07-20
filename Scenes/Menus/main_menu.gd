extends Control
#@onready var WorldMap: PackedScene = load("res://Scenes/Menus/WorldMap.tscn")
@onready var WorldMap: String = "res://Scenes/Levels/Level1.tscn"
@onready var loadingScreen: PackedScene = load("res://Scenes/Menus/LoadingScreen.tscn")
#@onready var S
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_4_pressed() -> void:
	get_tree().quit()


func _on_button_pressed() -> void:
	Global.sceneToLoadPath = WorldMap
	get_tree().change_scene_to_packed(loadingScreen)


func _on_button_2_pressed() -> void:
	pass


#func _on_button_3_pressed() -> void:
	#get_tree().change_scene_to_packed()
