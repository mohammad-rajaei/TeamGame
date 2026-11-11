extends CharacterBody3D

#for rotation 
@export var rotation_tolerance: float = 0.9	 

#other variable
@export var base_speed: float = 3.0
@export var run_speed: float = 6.0

@onready  var camera = $CameraController/Camera3D

var movement_input := Vector2.ZERO
#-----------------------------------------
#jump_section
@export var jump_hight: float = 2.5
@export var jump_time_to_peak : float = 0.4
@export var jup_tim_to_descent: float = 0.3

@onready var jump_volacity: float = ((2.0 * jump_hight) / jump_time_to_peak) * -1.0
@onready var jump_gravity:float = ((-2.0 * jump_hight) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity:float = ((-2.0 * jump_hight) / (jump_time_to_peak * jup_tim_to_descent)) * -1.0

func jump_logic(delta) -> void:	
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = -jump_volacity
	else:
		$PlayerSkin.set_move_state('jumping')
	var gravity = jump_gravity if velocity.y > 0.0 else fall_gravity
	velocity.y -= gravity * delta
	
	


#-------------------------------------------
#move_section


func move_logic(delta: float) -> void:
	movement_input = Input.get_vector("left", "right", "forward", "backward"
	).rotated(-camera.global_rotation.y)

	var vel_2d = Vector2(velocity.x, velocity.z)
	var is_running = Input.is_action_pressed("run")
	var speed = run_speed if is_running else base_speed

	if movement_input != Vector2.ZERO:
		var target_angle = -movement_input.angle() + PI / 2
		$PlayerSkin.rotation.y = rotate_toward($PlayerSkin.rotation.y, target_angle, 4.5 * delta)
		var rotation_error = abs(wrapf(target_angle - $PlayerSkin.rotation.y, -PI, PI))

		if rotation_error < rotation_tolerance:
			var target_velocity = movement_input * speed
			vel_2d = vel_2d.move_toward(target_velocity, speed * 12.0 * delta)

			$PlayerSkin.set_move_state('walking')
		else:
			vel_2d = vel_2d.move_toward(Vector2.ZERO, run_speed * 15.0 * delta)

			$PlayerSkin.set_move_state('idle')

	else:
		vel_2d = vel_2d.move_toward(
			Vector2.ZERO,
			run_speed * 15.0 * delta
		)

		$PlayerSkin.set_move_state('idle')

	velocity.x = vel_2d.x
	velocity.z = vel_2d.y


#-------------------------------------------
# nain loop
func _physics_process(delta: float) -> void:
	move_logic(delta)
	jump_logic(delta)
	move_and_slide()
	
