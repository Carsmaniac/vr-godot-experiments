extends Node3D

var left_hand_closed: bool = false
var right_hand_closed: bool = false

var l_pointing: bool = false
var l_thumbing: bool = false
var r_pointing: bool = false
var r_thumbing: bool = false

var constant_size_change = 1.007
var step_size_change = 1.2
var point_direction_threshold = 0.5
var move_speed = 0.02

var movement_enabled = true
var mini_experiment: int = 8
# 1: greater variations in user scale (fist)
# 2: user scale that changes over time (fist)
# 3: (not possible in Godot?)
# 6: changing object scales disproportionally
# 7: changing scale in reaction to user actions (point and thumbs up)
# 8: changing scale in reaction to user actions (point up and down)

@export var origin_node: Node3D
@export var left_hand: Node3D
@export var right_hand: Node3D


func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if mini_experiment == 2:
		if left_hand_closed:
			rescale(constant_size_change)
		elif right_hand_closed:
			rescale(1/constant_size_change)
			
	elif mini_experiment == 7:
		if l_pointing:
			rescale(constant_size_change)
		elif l_thumbing:
			rescale(1/(constant_size_change))
		
		if r_pointing:
			rescale(constant_size_change)
		elif r_thumbing:
			rescale(1/(constant_size_change))
			
	elif mini_experiment == 8:
		if l_pointing:
			if abs(left_hand.rotation_degrees.z) < 80:
				rescale(1/(constant_size_change))
			elif abs(left_hand.rotation_degrees.z) > 100:
				rescale(constant_size_change)
			#print(left_hand.rotation_degrees)
				
	if movement_enabled:
		if r_pointing:
			var movement_vector = Vector2(-move_speed, 0)
			movement_vector = movement_vector.rotated(right_hand.global_rotation.y)
			origin_node.position.x += movement_vector.x
			origin_node.position.z += -movement_vector.y
		
func rescale(rescale_factor: float):
	self.scale *= rescale_factor
	
	var user_pos = origin_node.find_child("XRCamera3D").global_position
	var rel_pos = user_pos - self.position
	
	origin_node.position.x += rel_pos.x * (rescale_factor - 1)
	origin_node.position.z += rel_pos.z * (rescale_factor - 1)
	# 6 months stuck on this and it was this straightforward, oops


func _on_left_pose_started(p_name: String) -> void:
	if p_name == "Fist":
		left_hand_closed = true
		if mini_experiment == 1:
			rescale(1/step_size_change)
	elif p_name == "Point":
		l_pointing = true
	elif p_name == "ThumbsUp":
		l_thumbing = true

func _on_left_pose_ended(_p_name: String) -> void:
	left_hand_closed = false
	l_pointing = false
	l_thumbing = false

func _on_right_pose_started(p_name: String) -> void:
	if p_name == "Fist":
		right_hand_closed = true
		if mini_experiment == 1:
			rescale(step_size_change)
	elif p_name == "Point":
		r_pointing = true
	elif p_name == "ThumbsUp":
		r_thumbing = true

func _on_right_pose_ended(_p_name: String) -> void:
	right_hand_closed = false
	r_pointing = false
	r_thumbing = false
