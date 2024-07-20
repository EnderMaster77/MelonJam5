extends Area2D
var player_in_area: bool = false
@export var player: CharacterBody2D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") && player_in_area == true:
		if player.holding_flame == true:
			print("Level Complete!")


func _on_body_entered(body: Node2D) -> void:
	if body == player:
		player_in_area = true


func _on_body_exited(body: Node2D) -> void:
	if body == player:
		player_in_area = false
