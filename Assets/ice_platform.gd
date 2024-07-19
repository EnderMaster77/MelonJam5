extends StaticBody2D

func _ready() -> void:
	$AnimatedSprite2D.play("Default")
	$AnimatedSprite2D.pause()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if $AnimatedSprite2D.is_playing() == false:
		$AnimatedSprite2D.play("Melting")


func _on_animated_sprite_2d_animation_finished() -> void:
	set_collision_layer_value(1,false)
	$AnimatedSprite2D.hide()
	$RespawnTimer.start()


func _on_respawn_timer_timeout() -> void:
	$AnimatedSprite2D.show()
	$AnimatedSprite2D.play("Default")
	$AnimatedSprite2D.pause()
	set_collision_layer_value(1,true)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if $AnimatedSprite2D.is_playing() == false:
		$AnimatedSprite2D.play("Melting")
