extends CharacterBody2D

var holding_flame: bool = false

const SPEED = 700.0
const JUMP_VELOCITY = -400.0
@onready var cam : Camera2D = $Camera2D

@onready var dashVisualPercent: Material = $DashCircle.material
@onready var flowVisualPercent: Material = $FlowShiftCircle.material
@onready var aberrationEffect: Material = $CanvasLayer/Abberation.material

@export var maxDashTime: float = 5
var dashTime: float = 5

var translateEffectMod: float = 0.0

var in_water: bool = false
var on_water: bool = false

var momentumToTranslate: Vector2 = Vector2.ZERO
var clickPos: Vector2 = Vector2.ZERO

var canUseFlowShift: bool = true


func _process(delta: float) -> void:
	if holding_flame == true:
		modulate = Color(1,0,0,1)
	else:
		modulate = Color(1,1,1,1)
	flowVisualPercent.set_shader_parameter("fill_ratio", ($FlowShiftTimer.time_left - 0.5)/($FlowShiftTimer.wait_time - 0.5) )
	if dashTime >= maxDashTime:
		dashVisualPercent.set_shader_parameter("fill_ratio", 0 )
		dashTime = maxDashTime
	elif Input.is_action_pressed("dash") == false or in_water == false:
		dashTime += delta
	if in_water == true:
		$Sprite2D.look_at(get_global_mouse_position())
		cam.offset = lerp(cam.offset, get_local_mouse_position()/3,delta *5)
		if Input.is_action_pressed("translate_momentum") && canUseFlowShift == true:
			cam.zoom = lerp(cam.zoom, Vector2(0.75,0.75), delta * 4)
		else:
			cam.zoom = lerp(cam.zoom, Vector2(0.5,0.5), delta * 10)
	else:
		cam.offset = lerp(cam.offset, velocity/3, delta * 5)
		if velocity.y <= -750:
			cam.zoom.y = lerpf(cam.zoom.y,0.5/(abs(velocity.y)/700), delta * 8)
			cam.zoom.x = cam.zoom.y
		else:
			cam.zoom = lerp(cam.zoom, Vector2(0.5,0.5), delta * 4)
		
func _physics_process(delta: float) -> void:
		
	
	
		
		
	
	dashVisualPercent.set_shader_parameter("fill_ratio", (dashTime - 0.5)/(maxDashTime - 0.5) )
	if dashTime >= maxDashTime:
		dashVisualPercent.set_shader_parameter("fill_ratio", 0 )
		dashTime = maxDashTime
	elif Input.is_action_pressed("dash") == false or in_water == false:
		dashTime += delta * (1/3)
	if in_water == true:
		water_mobility(delta)
	else:
		land_mobility(delta)
	if on_water == true && Input.is_action_pressed("down") && in_water == false:
		holding_flame = false
		$CollisionShape2D.shape.size.y = 128
		velocity.y = 300
		set_collision_mask_value(2, false)
		in_water = true
	move_and_slide()


func water_mobility(delta: float):
	var direction:Vector2 = (get_global_mouse_position() - global_position).normalized()
	if Input.is_action_just_pressed("translate_momentum") && canUseFlowShift == true:
		momentumToTranslate.x = abs(velocity.x)
		momentumToTranslate.y = abs(velocity.y)
		velocity = Vector2.ZERO
		
	
	if Input.is_action_just_released("translate_momentum") && canUseFlowShift == true:
		canUseFlowShift = false
		#if momentumToTranslate.x + momentumToTranslate.y < SPEED:
		#	momentumToTranslate = momentumToTranslate * (SPEED /4)
		velocity = momentumToTranslate * direction * 3
		$CanvasLayer/Abberation.hide()
		$CanvasLayer/Vignette.hide()
		var ab = Vector2.ONE
		aberrationEffect.set_shader_parameter("r_displacement", ab)
		aberrationEffect.set_shader_parameter("b_displacement", ab)
		aberrationEffect.set_shader_parameter("g_displacement", -ab)
		$CanvasLayer/Vignette.material.set_shader_parameter("inner_radius", 1/translateEffectMod)
		$FlowShiftTimer.start()
	elif Input.is_action_pressed("translate_momentum") && canUseFlowShift == true:
		velocity = Vector2.ZERO
		#velocity = lerp(velocity,Vector2.ZERO, delta * 20)
		$CanvasLayer/Abberation.show()
		$CanvasLayer/Vignette.show()
		translateEffectMod += delta * 3
		translateEffectMod = clampf(translateEffectMod, 1,10)
		var ab = lerp(aberrationEffect.get_shader_parameter("r_displacement"),Vector2(-translateEffectMod,-translateEffectMod/3),delta * 4)
		aberrationEffect.set_shader_parameter("r_displacement", ab)
		aberrationEffect.set_shader_parameter("b_displacement", ab * 1.4)
		aberrationEffect.set_shader_parameter("g_displacement", ab * 1.2)
		$CanvasLayer/Vignette.material.set_shader_parameter("inner_radius", 1/translateEffectMod)
		return
	# Swims toward mouse.
	
	if Input.is_action_pressed("dash") && dashTime > 0:
		dashTime -= delta * 2
		if compareVector2(velocity, SPEED * 2) == true:
			velocity = lerp(velocity,direction * SPEED * 2, delta)
		else:
			velocity = lerp(velocity,direction * SPEED * 2, delta * 10)
	elif Input.is_action_pressed("jump"):
			velocity = lerp(velocity,direction * SPEED, delta * 8)
	else:
		var motion_dir = Input.get_vector("left","right","up","down").normalized()
		if motion_dir:
			velocity = lerp(velocity, motion_dir * 400,delta)
			

func land_mobility(delta: float):
	$Sprite2D.rotation_degrees = lerpf($Sprite2D.rotation_degrees, 0 , delta * 6)
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY * 1.5

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		if sign(direction) != sign(velocity.x):
			velocity.x = lerpf(velocity.x, direction * SPEED, delta * 8)
		elif compareVector2(velocity, SPEED) == true:
			velocity.x = lerpf(velocity.x, direction * SPEED, delta / 2)
		else:
			velocity.x = lerpf(velocity.x, direction * SPEED, delta * 4)
	else:
		velocity.x = lerpf(velocity.x, 0, delta * 8)


func _on_area_2d_body_entered(body: Node2D) -> void:
	$CollisionShape2D.shape.size.y = 64
	set_collision_mask_value(2, true)
	
	on_water = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	("out")
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
			


func _on_floating_water_detection_body_entered(body: Node2D) -> void:
	in_water = true
	holding_flame


func _on_floating_water_detection_body_exited(body: Node2D) -> void:
	in_water = false
	velocity.x *= 1.5
	velocity.y *= 1
	if translateEffectMod != 1:
		translateEffectMod = 1 
		$CanvasLayer/Abberation.hide()
		$CanvasLayer/Vignette.hide()
		var ab = Vector2.ONE
		aberrationEffect.set_shader_parameter("r_displacement", ab)
		aberrationEffect.set_shader_parameter("b_displacement", ab)
		aberrationEffect.set_shader_parameter("g_displacement", -ab)
		$CanvasLayer/Vignette.material.set_shader_parameter("inner_radius", 1/translateEffectMod)


func _on_flow_shift_timer_timeout() -> void:
	canUseFlowShift = true

func compareVector2(vec:Vector2, compVal:float):
	var compVec = vec.normalized() * compVal
	if vec.abs().x + vec.abs().y > compVec.abs().x + compVec.abs().y:
		return true
	else:
		return false
