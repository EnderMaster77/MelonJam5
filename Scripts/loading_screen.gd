extends Control
class_name loadScreen
@export var sceneToLoadPath: String
var scene_load_status = 0
# Called when the node enters the scene tree for the first time.
var progress:Array = []
func _ready():
	sceneToLoadPath = Global.sceneToLoadPath
	ResourceLoader.load_threaded_request(sceneToLoadPath)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scene_load_status = ResourceLoader.load_threaded_get_status(sceneToLoadPath, progress)
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		var newscene = ResourceLoader.load_threaded_get(sceneToLoadPath)
		get_tree().change_scene_to_packed(newscene)
