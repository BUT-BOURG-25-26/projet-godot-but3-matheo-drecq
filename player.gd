extends CharacterBody3D

var speed_forward = 10.0
var lane_distance = 4.0
var jump_velocity = 8.0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var current_lane = 0
var target_lane = 0

func _physics_process(delta):
	velocity.z = -speed_forward

	var target_x = target_lane * lane_distance
	var diff = target_x - global_position.x
	velocity.x = diff * 10.0

	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		if Input.is_action_just_pressed("Jump"):
			velocity.y = jump_velocity

	move_and_slide()

func _input(event):
	if event.is_action_pressed("Switch_Left"):
		if target_lane > -1:
			target_lane -= 1
	elif event.is_action_pressed("Switch_Right"):
		if target_lane < 1:
			target_lane += 1
