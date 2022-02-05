extends Control

onready var player = null
onready var evolve_list := $Evolutions

var evolution_options := []

func get_evolution_options():
	var class_evolutions = []
	for child in PlayerClass.class_hierarchy.find_class(Stats.player.get("classname")).get_children():
		class_evolutions.append(child)
	return class_evolutions

func create_evolution_button(classname : String):
	var button = Button.new()
	button.text = classname
	button.connect("pressed", self, "evolve_player", [button.text])
	evolve_list.add_child(button)

func display_evolutions():
	evolution_options = get_evolution_options()
	for option in evolution_options:
		create_evolution_button(option.get_name())

func evolve_player(classname : String):
	for option in evolution_options:
		if option.get_name() == classname: 
			Stats.evolve(PlayerClass.get_class_data(option))
	for child in evolve_list.get_children():
		child.disconnect("pressed", self, "evolve_player")
		evolve_list.remove_child(child)
