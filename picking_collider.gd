extends Area3D

enum hand_sides{LEFT_HAND, RIGHT_HAND}
@export var which_hand: hand_sides
@export var falling_wall: Node

var pickable_objects: Array[Node3D] = []
var held_object: Node3D
var held_object_prev_parent: Node3D
var held_object_rel_pos: Vector3
var held_object_rel_rot: Vector3


func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if held_object:
		held_object.position = self.position + held_object_rel_pos
		held_object.rotation = self.rotation + held_object_rel_rot

func _on_body_entered(body: Node3D) -> void:
	if body is PickableObject:
		pickable_objects.append(body)

func _on_body_exited(body: Node3D) -> void:
	pickable_objects.erase(body)

func _on_right_hand_pose_started(p_name: String) -> void:
	if which_hand == hand_sides.RIGHT_HAND:
		if p_name == "Fist":
			var min_dist: float
			for obj in pickable_objects:
				if !min_dist or obj.position.distance_to(self.position) < min_dist:
					held_object = obj
					held_object_prev_parent = obj.get_parent()
					held_object.reparent(self)
					held_object.freeze = false
					held_object.gravity_scale = 0
					held_object_rel_pos = held_object.position - self.position
					held_object_rel_rot = held_object.rotation - self.rotation
					held_object.picked_up.emit()

func _on_right_hand_pose_ended(_p_name: String) -> void:
	if which_hand == hand_sides.RIGHT_HAND:
		if held_object:
			held_object.reparent(held_object_prev_parent)
			held_object.gravity_scale = 1
			held_object = null

func _on_left_hand_pose_started(p_name: String) -> void:
	if which_hand == hand_sides.LEFT_HAND:
		if p_name == "Fist":
			var min_dist: float
			for obj in pickable_objects:
				if !min_dist or obj.position.distance_to(self.position) < min_dist:
					held_object = obj
					held_object_prev_parent = obj.get_parent()
					held_object.reparent(self)
					held_object.gravity_scale = 0
					held_object_rel_pos = held_object.position - self.position
					held_object_rel_rot = held_object.rotation - self.rotation
	

func _on_left_hand_pose_ended(_p_name: String) -> void:
	if which_hand == hand_sides.LEFT_HAND:
		if held_object:
			held_object.reparent(held_object_prev_parent)
			held_object.gravity_scale = 1
			held_object = null
