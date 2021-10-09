extends Node2D

onready var player := get_tree().current_scene.find_node("Player")
onready var gui := PlayerUI

signal stat_level_up

var level := 1
var xp := 0 setget set_xp
var stat_points := 0 setget set_stat_points
var max_level := 20
var max_stat_level := 5
export var xp_req = [10, 15, 20, 30, 40, 50, 65, 80, 100, 120, 140, 160, 180, 200, 225, 250, 275, 300, 350]

var hp_level := 0
var hp_upgrade := [100, 150, 200, 275, 350, 500]
var hp_level_upgrade := 20

var def_level := 0
var armor_upgrade := [5, 7, 10, 14, 20, 30]

var dmg_level := 0
var bullet_damage_upgrade := [6, 8, 12, 15, 20, 30]
var bullet_speed_upgrade := [500, 550, 600, 675, 750, 900]

var rof_level := 0
var rof_base := 2.5
var rof_upgrade := [1.0, 1.1, 1.2, 1.35, 1.5, 1.75]

var spd_level := 0
var spd_max_speed_upgrade := [200, 230, 260, 300, 350, 400]
var spd_acceleration_upgrade := [500, 600, 700, 850, 1000, 1250]
var spd_friction_upgrade := [0.5, 0.525, 0.55, 0.575, 0.6, 0.65]

func _ready(): #detects player and sets ui's health and experience bars
	if player == null:
		gui.queue_free()
		queue_free()
	
	gui.connect("stat_level_up", self, "stat_level_up")
	set_ui_xp(xp, xp_req[level])
	gui.update_level_label()
	gui.update_stat_points_label()
	gui.update_stat_bars()

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
	player.max_hp += Stats.hp_level_upgrade
	player.hp = player.max_hp
	set_ui_hp(player.hp, player.max_hp)
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
