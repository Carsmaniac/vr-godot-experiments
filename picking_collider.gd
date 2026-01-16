extends Area3D

var pickable_objects: Array[Node3D] = []
var held_object: Node3D
var held_object_prev_parent: Node3D
var held_object_rel_pos: Vector3
var held_object_rel_rot: Vector3

@onready var sound_player: Node = find_child("AudioStreamPlayer")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if held_object:
		held_object.position = self.position + held_object_rel_pos
		held_object.rotation = self.rotation + held_object_rel_rot


func _on_body_entered(body: Node3D) -> void:
	if body.find_child("PickableObject"):
		pickable_objects.append(body)


func _on_body_exited(body: Node3D) -> void:
	pickable_objects.erase(body)


func _on_right_hand_pose_started(p_name: String) -> void:
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


func _on_right_hand_pose_ended(_p_name: String) -> void:
	if held_object:
		held_object.reparent(held_object_prev_parent)
		held_object.gravity_scale = 1
		held_object = null
