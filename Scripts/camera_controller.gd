extends Node3D

@export var min_limit_x: float
@export var max_limit_x: float
@export var horizantal_acceleration := 2.0
@export var vertical_acceleration := 1.0
@export var mouse_acceleration:= 0.005 # sorat charkhesh mouse

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

#controler vision settings
func _process(delta: float) -> void:
	var joy_dir = Input.get_vector("pan_left", "pan_right", "pan_up", "pan_down")
	rotate_from_vector(	joy_dir * delta * Vector2(horizantal_acceleration, vertical_acceleration))

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_from_vector(event.relative  * mouse_acceleration) 
	

func rotate_from_vector(v: Vector2):
	if v.length() == 0: return 
	rotation.y -= v.x
	rotation.x -= v.y
	rotation.x = clamp(rotation.x, min_limit_x, max_limit_x)
		
