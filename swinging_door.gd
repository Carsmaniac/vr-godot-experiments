extends Node3D
var unlocked:bool = false
@export var door_handle:Node3D


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	pass


func move_door_handle() -> void:
	door_handle.reparent(self)
	door_handle.position = Vector3(-0.89, 0.993, -0.04)
	door_handle.reparent(get_parent())
