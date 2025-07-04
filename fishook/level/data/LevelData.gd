extends Resource
class_name LevelData

enum LevelType {
	REACH_THE_END,
	COLLECTATHON
}
@export var name: String = "Missing_Name"
@export var comment: String = "No Comment"
@export var scene_name: String = "Level1"
@export var difficulty: int = 0
@export var type: LevelType = LevelType.REACH_THE_END
@export_file("*.tscn") var miniature_scene_path: String = ""
