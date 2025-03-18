extends Marker3D
class_name BaseCheckpoint

signal reached(checkpoint: BaseCheckpoint)

@export var override_shape: CollisionShape3D = null
@export var override_model: MeshInstance3D = null

@export var base_color: Color = Color("ffffff")
@export var color_on_reach: Color = Color("70ff7c")

@onready var area: Area3D = %Area3D
@onready var hitbox: CollisionShape3D = %Hitbox
@onready var model_container: Node3D = %ModelContainer

var model: MeshInstance3D = null
var mesh: Mesh = null


func _ready():
	area.body_entered.connect(_on_checkpoint_reached)
	model = model_container.get_children().get(0)
	if model:
		mesh = model.mesh

func _on_checkpoint_reached(_body):
	reached.emit(self)
	if mesh:
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(mesh.material, "albedo_color", color_on_reach, 0.3).set_ease(Tween.EASE_OUT)
		await tween.finished
		var tween2: Tween = get_tree().create_tween()
		tween2.tween_property(mesh.material, "albedo_color", base_color, 1).set_ease(Tween.EASE_IN_OUT)
