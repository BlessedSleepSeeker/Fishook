extends Node3D
class_name ParticlesManager


func emit(particle_name: String):
	for child: GPUParticles3D in get_children():
		if child.name == particle_name:
			child.restart()

func stop(particle_name: String):
	for child: GPUParticles3D in get_children():
		if child.name == particle_name:
			child.emitting = false