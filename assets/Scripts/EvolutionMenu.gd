extends Control

signal class_evolved

onready var player = null
onready var evolve_list := $Evolutions

var can_evolve := false
var evolution_options := []

func get_evolution_options():
	var class_evolutions = []
	for child in PlayerClass.class_hierarchy.find_class(player.get("classname")).get_children():
		class_evolutions.append(child.get_name)
	return class_evolutions

func create_evolution_button(classname : String):
	var button = Button.new()
	button.text = classname
	evolve_list.add_child(button)

func display_evolutions():
	evolution_options = get_evolution_options()
	for option in evolution_options:
		create_evolution_button(option)
