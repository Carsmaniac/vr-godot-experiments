extends Node3D

@export var door_node: Node
@export var door_handle: Node
var falling: bool = false
var falling_speed: float = 0.001


func _ready() -> void:
	door_handle.picked_up.connect(start_falling)


func _process(_delta: float) -> void:
	if falling:
		if self.rotation.x < deg_to_rad(90):
			self.rotation.x += falling_speed
			falling_speed *= 1.065
		else:
			self.rotation.x = deg_to_rad(90)

func start_falling() -> void:
	falling = true
