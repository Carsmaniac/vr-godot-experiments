extends Node3D
var unlocked:bool = false
var door_handle:Node3D
var relative_position: Vector3


func _ready() -> void:
	pass
	door_handle = get_node("%DoorHandle")
	door_handle.dropped.connect(move_door_handle)
	#move_door_handle()


func _process(_delta: float) -> void:
	pass
	#rotation.y = global_position.angle_to(door_handle.global_position) - deg_to_rad(90)
	relative_position = global_position - door_handle.global_position
	rotation.y = atan(relative_position.x / relative_position.z) - deg_to_rad(90)
	

func move_door_handle() -> void:
	door_handle.reparent(self)
	door_handle.position = Vector3(-0.89, 0.993, -0.04)
	door_handle.rotation = Vector3.ZERO
	door_handle.freeze = true
	door_handle.reparent(get_parent())
