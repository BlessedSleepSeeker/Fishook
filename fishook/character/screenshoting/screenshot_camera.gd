extends Node3D
class_name ScreenshotCamera

@onready var viewport: SubViewport = %ScreenshotViewport
@onready var camera: Camera3D = %Camera3D
@onready var marker: Marker3D = %Marker3D

var pictures: Array[Image] = []


func snap_picture() -> void:
	await RenderingServer.frame_post_draw
	pictures.append(viewport.get_texture().get_image())


func _physics_process(_delta):
	camera.global_position = marker.global_position
	if camera.global_position != self.global_position:
		camera.look_at(self.global_position)

func return_random_pic() -> ImageTexture:
	if pictures.size() > 0:
		var img: Image = pictures.pick_random()
		var texture: ImageTexture = ImageTexture.create_from_image(img)
		return texture
	else:
		return null