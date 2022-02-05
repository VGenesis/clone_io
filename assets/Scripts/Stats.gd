extends Node2D

signal evolution_available

onready var player := get_tree().current_scene.find_node("Player")
onready var gui := PlayerUI

var level := 9
var evolution_level = 10
var max_level := 20
var max_stat_level := 5
var xp := 110 setget set_xp
export var xp_req = [10, 15, 20, 30, 40, 50, 65, 80, 100, 120, 140, 160, 180, 200, 225, 250, 275, 300, 350]

var stat_points := 0 setget set_stat_points
var hp_level := 0
var def_level := 0
var dmg_level := 0
var rof_level := 0
var spd_level := 0

var evolution_stats = null

func _ready(): #detects player and sets ui's health and experience bars
	if player == null:
		gui.queue_free()
		queue_free()
	
	gui.connect("stat_level_up", self, "stat_level_up")
	connect("evolution_available", gui, "show_evolution_menu")
	set_ui_xp(xp, xp_req[level])
	gui.update_level_label()
	gui.update_stat_points_label()
	gui.update_stat_bars()
	gui.evolve_menu.player = player	

func set_evolution_data():
	evolution_stats = PlayerClass.get_class_data(PlayerClass.class_hierarchy.find_class(player.classname))
	player.evolve()

func set_xp(value): #adds experience and levels up if experience has passed the threshold
	while level < max_level and value >= xp_req[level - 1]:
		value -= xp_req[level - 1]
		level_up()
	if(level < max_level):
		xp = value
		set_ui_xp(xp, xp_req[level - 1])
	else:
		xp = 0
		set_ui_xp(1, 1)

func set_stat_points(value):
	stat_points = value
	gui.update_stat_points_label()

func level_up(): #levels up, adds a stat point and increases player's max hp
	level += 1
	self.stat_points += 1
	if level == evolution_level:
		emit_signal("evolution_available")
	gui.update_level_label()

func stat_level_up(stat : String): #Levels up a stat
	var stat_name = stat + "_level"
	if stat_points > 0 and get(stat_name) < max_stat_level:
		player.stat_level_up(stat)

func set_ui_hp(value, max_value):
	gui.healthbar.value = value
	gui.healthbar.max_value = max_value

func set_ui_xp(value, max_value):
	gui.expbar.value = value
	gui.expbar.max_value = max_value

func evolve(class_stats : Dictionary):
	evolution_stats = class_stats
	player.evolve()
