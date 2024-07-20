extends Area2D
var player_in_area: bool = false
@export var Player: player

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") && player_in_area == true:
		if Player.holding_flame == true:
			print("Level Complete!")
			Global.levelComplete = true


func _on_body_entered(body: Node2D) -> void:
	Player = body
	player_in_area = true


func _on_body_exited(body: Node2D) -> void:
	Player = body
	player_in_area = false
