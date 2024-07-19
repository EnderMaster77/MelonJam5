extends CharacterBody2D


const SPEED = 700.0
const JUMP_VELOCITY = -400.0
@onready var cam : Camera2D = $Camera2D
@onready var dashVisualPercent = $DashCircle.material
@export var maxDashTime: float = 5
var dashTime: float = 5

var in_water: bool = false
var on_water: bool = false


func _process(delta: float) -> void:
	if in_water == true:
		$Sprite2D.look_at(get_global_mouse_position())
		cam.offset = lerp(cam.offset, get_local_mouse_position()/3,delta *5)
	else:
		cam.offset = lerp(cam.offset, velocity/3, delta * 5)
		
func _physics_process(delta: float) -> void:
	if on_water == true && Input.is_action_just_pressed("down") && in_water == false:
		in_water = true
		$CollisionShape2D.shape.size.y = 128
		velocity.y = 200
		set_collision_mask_value(2, false)
		in_water = true
		
		
	
	dashVisualPercent.set_shader_parameter("fill_ratio", (dashTime - 0.5)/(maxDashTime - 0.5) )
	if dashTime >= maxDashTime:
		dashVisualPercent.set_shader_parameter("fill_ratio", 0 )
		dashTime = maxDashTime
	elif Input.is_action_pressed("dash") == false or in_water == false:
		dashTime += delta
	if in_water == true:
		water_mobility(delta)
	else:
		land_mobility(delta)

	move_and_slide()


func water_mobility(delta: float):
	
	
	# Swims toward mouse.
	if Input.is_action_pressed("dash") && dashTime > 0:
		dashTime -= delta * 2
		velocity = lerp(velocity,(get_global_mouse_position() - global_position).normalized() * SPEED * 2, delta * 10)
	elif Input.is_action_pressed("jump"):
		velocity = lerp(velocity,(get_global_mouse_position() - global_position).normalized() * SPEED, delta * 8)
	else:
		var motion_dir = Input.get_vector("left","right","up","down").normalized()
		if motion_dir:
			velocity = lerp(velocity, motion_dir * 400,delta)
		else:
			velocity = lerp(velocity, Vector2.ZERO, delta * 2)
			
	
	#print(dashTime)

func land_mobility(delta: float):
	$Sprite2D.rotation_degrees = lerpf($Sprite2D.rotation_degrees, 0 , delta * 6)
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		if sign(direction) != sign(velocity.x):
			velocity.x = lerpf(velocity.x, direction * SPEED, delta * 8)
		elif abs(velocity.x) > SPEED:
			velocity.x = lerpf(velocity.x, direction * SPEED, delta / 2)
		else:
			velocity.x = lerpf(velocity.x, direction * SPEED, delta * 4)
	else:
		velocity.x = lerpf(velocity.x, 0, delta * 8)


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("in")
	$CollisionShape2D.shape.size.y = 64
	set_collision_mask_value(2, true)
	on_water = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	print("out")
	$CollisionShape2D.shape.size.y = 128
	set_collision_mask_value(2, false)
	if in_water == true:
		if Input.is_action_pressed("dash"):
			in_water = false
			on_water = false
			velocity.x *= 1.5
			velocity.y *= 1
		else:
			in_water = false
			velocity.y = 0 
			
