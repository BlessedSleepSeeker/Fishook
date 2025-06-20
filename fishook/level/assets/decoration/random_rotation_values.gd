extends Resource
class_name RandomRotationValues

@export_range(-360, 360, 0.1, "radians_as_degrees") var rotation_x_min: float = deg_to_rad(-10)
@export_range(-360, 360, 0.1, "radians_as_degrees") var rotation_x_max: float = deg_to_rad(10)
@export_range(-360, 360, 0.1, "radians_as_degrees") var rotation_y_min: float = deg_to_rad(-10)
@export_range(-360, 360, 0.1, "radians_as_degrees") var rotation_y_max: float = deg_to_rad(10)
@export_range(-360, 360, 0.1, "radians_as_degrees") var rotation_z_min: float = deg_to_rad(-10)
@export_range(-360, 360, 0.1, "radians_as_degrees") var rotation_z_max: float = deg_to_rad(10)