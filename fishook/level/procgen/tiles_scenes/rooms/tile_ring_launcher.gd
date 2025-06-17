extends AlgorithmTileScene
class_name TileLauncher

@export var velocity_decrease_time: float = 1
@export var launch_windup_time: float = 2
@export var launch_direction: Vector3 = Vector3(1, 0, 0)
@export var launch_power: float = 80
@export var post_launch_wait: float = 4
@export var post_launch_character_state: String = "Fall"

@onready var boost_area: Area3D = %BoostArea
@onready var anim_player: AnimationPlayer = %AnimationPlayer

func _ready():
	boost_area.body_entered.connect(on_boost_entered)


func on_boost_entered(body: Node3D) -> void:
	if body is CharacterInstance:
		anim_player.play("launch")
		body.state_machine.transition_to("Launched", {"velocity_decrease_time": velocity_decrease_time, "launcher_center_position": boost_area.get_node("CollisionShape3D").global_position})
		await get_tree().create_timer(launch_windup_time).timeout
		var velo = (launch_direction * launch_power)
		body.velocity = velo.rotated(Vector3.UP, self.rotation.y)
		body.state_machine.transition_to("Cinematic", {"animation_name": "Launched"})
		#print(body.velocity)
		await get_tree().create_timer(post_launch_wait).timeout
		body.state_machine.transition_to(post_launch_character_state)
