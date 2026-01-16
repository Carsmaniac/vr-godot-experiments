extends Node3D

var left_hand_closed: bool = false
var right_hand_closed: bool = false

var mini_experiment: int = 1
# 1: greater variations in user scale
# 2: user scale that changes over time
# 3: (not possible in Godot?)
# 6: changing object scales disproportionally
# 7: changing scale in reaction to user actions

@export var origin_node: Node



func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if mini_experiment == 2:
		if left_hand_closed:
			rescale(1/1.01)
		elif right_hand_closed:
			rescale(1.01)
	pass
		
func rescale(rescale_factor: float):
	self.scale *= rescale_factor
	
	var user_pos = origin_node.find_child("XRCamera3D").position
	var rel_pos = user_pos - self.position
	
	origin_node.position.x += rel_pos.x * (rescale_factor - 1)
	origin_node.position.z += rel_pos.z * (rescale_factor - 1)
	# 6 months stuck on this and it was this straightforward, oops



func _on_left_pose_started(p_name: String) -> void:
	if p_name == "Fist":
		left_hand_closed = true
		if mini_experiment == 1:
			rescale(1/1.2)

func _on_left_pose_ended(_p_name: String) -> void:
	left_hand_closed = false

func _on_right_pose_started(p_name: String) -> void:
	if p_name == "Fist":
		right_hand_closed = true
		if mini_experiment == 1:
			rescale(1.2)

func _on_right_pose_ended(_p_name: String) -> void:
	right_hand_closed = false
