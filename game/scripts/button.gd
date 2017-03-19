
extends Control

# member variables here, example:
var juego = preload("res://helloScene.tscn")
var tapped = false

func _ready():
	pass

func _on_ok_pressed():
	get_node("PopupPanel").hide()


func _on_creditos_pressed():
	get_node("PopupPanel").popup()


func _on_dos_jugadores_pressed():
#	get_node("/root/scene_manager").set_scene("res://helloScene.tscn")
	get_tree().change_scene("res://helloScene.tscn")
