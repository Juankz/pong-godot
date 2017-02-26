
extends Node

var current_scene = null

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count()-1)
	pass
func set_scene(scene):
	var new_scene = ResourceLoader.load(scene)
	current_scene.queue_free()
	current_scene = new_scene.instance()
	get_tree().get_root().add_child(current_scene)
	


