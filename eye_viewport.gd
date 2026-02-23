extends SubViewport

var cam: Camera3D
var cam_image
var cam_texture

var xr_interface: XRInterface
@export var origin_node: Node3D

func _ready() -> void:
	cam = find_child("Camera3D")
	xr_interface = XRServer.find_interface("OpenXR")


func _process(_delta: float) -> void:
	#cam.transform = get_parent().get_parent().transform
	#cam.position += Vector3(0, 0, -0.02)
	call_deferred("set_cam_position")
	var left_eye_transform = xr_interface.get_transform_for_view(0, origin_node.global_transform)
	var right_eye_transform = xr_interface.get_transform_for_view(1, origin_node.global_transform)
	#print(left_eye_transform.origin - cam.global_basisposition)
	
	
func set_cam_position() -> void:
	cam.transform = xr_interface.get_transform_for_view(0, XRServer.world_origin)
	cam.position += Vector3(-0.02, 0, 0)
