extends Control
var config = ConfigFile.new()
# Create new ConfigFile object.

# Store some values.

# Save it to a file (overwrite if already exists).
#config.save("user://scores.cfg")
# Called when the node enters the scene tree for the first time.

func _unhandled_input(event: InputEvent) -> void:
	print(event)
	if event == InputEventMouseButton:
		config.set_value("Controls", "test", event)
		print("wer")

func _ready() -> void:
	if OS.get_name() == "Linux":
		$Panel/OptionButton.show()
	
	
	config.save("res://test.cfg")
	#ProjectSettings.set_setting("display/display_server/driver.linuxbsd","x11")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_4_pressed() -> void:
	config.save("res://test.cfg")
