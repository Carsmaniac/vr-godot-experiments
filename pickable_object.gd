class_name PickableObject
extends RigidBody3D

@export var eatable_object: bool
@export var eating_increases_scale: bool
@export var falling_door_handle: bool

@export var door_handle: bool
@export_enum("Regular", "Falling") var type_of_handle: String
signal picked_up
signal dropped
