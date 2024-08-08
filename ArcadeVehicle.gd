extends RigidBody3D

@export var GRIP := 50
@export var ROTATION := 0.3
@export var ACCELERATION := 6
@export var TURN := 3
@export var JUMP := 30

enum VehiclyType {Car, Motorcycle}
@export var VEHICLE_TYPE: VehiclyType

var active := false


func _physics_process(delta):
	if not active:
		return
	var position_node = $MeshInstance3D.get_global_transform()
	var can_accelerate = $RearLeft.is_colliding() or $RearRight.is_colliding()
	var can_turn = $FrontLeft.is_colliding() or $FrontRight.is_colliding()
	if Input.is_action_pressed("ui_up") and can_accelerate:
		apply_central_force(position_node.basis[2].normalized() * ACCELERATION * mass)
	if Input.is_action_pressed("ui_down") and can_accelerate:
		apply_central_force(position_node.basis[2].normalized() * -ACCELERATION * mass)
	if Input.is_action_pressed("ui_left") and can_turn:
		apply_torque(Vector3(0, TURN, 0) * mass)
		if VEHICLE_TYPE == VehiclyType.Motorcycle:
			apply_torque(position_node.basis[2] * -ROTATION * mass)
	if Input.is_action_pressed("ui_right") and can_turn:
		apply_torque(Vector3(0, -TURN, 0) * mass)
		if VEHICLE_TYPE == VehiclyType.Motorcycle:
			apply_torque(position_node.basis[2] * ROTATION * mass)
	if Input.is_action_pressed("ui_select"):
		apply_central_force(Vector3(0, JUMP, 0) * mass)
	var speed = linear_velocity.length()
	if speed > 1:
		var side_dir = position_node.basis[0].normalized()
		var steer_angle = rad_to_deg(acos(side_dir.dot(linear_velocity.normalized())))
		var force = Vector3(0, 0, 0)
		if steer_angle < 90:
			force = side_dir * -speed * GRIP
		elif steer_angle > 90:
			force = side_dir * speed * GRIP
		apply_central_force(force)
