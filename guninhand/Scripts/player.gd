extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var animation_player: AnimationPlayer = $"Robot Arm/AnimationPlayer"
var zoomstatus = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("shoot"):
		animation_player.play("shoot")
	if Input.is_action_just_pressed("zoom"):
		if zoomstatus:
			animation_player.play("unzoom")
			zoomstatus = false
		else:
			animation_player.play("zoom")
			zoomstatus = true
	print(animation_player.current_animation)
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector( "ui_right","ui_left", "ui_down","ui_up")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
