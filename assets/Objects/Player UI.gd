extends CanvasLayer

signal stat_level_up

onready var healthbar := $HealthBar
onready var expbar := $ExpBar
onready var level_label := $Level
onready var stat_label := $UpgradeTab/StatsText
onready var upgrade_labels := $UpgradeTab/HBoxContainer/Labels
onready var upgrade_buttons := $UpgradeTab/HBoxContainer/Buttons

var level_text := "Level: %s"
var stat_text := "Stat points: %s"
var hp_text := "HP: %s"
var def_text := "DEF: %s"
var dmg_text := "DMG: %s"
var rof_text := "ROF: %s"
var spd_text := "SPD: %s"

func update_level_label():
	level_label.text = level_text % str(Stats.level)

func update_stat_points_label():
	stat_label.text = stat_text % Stats.stat_points

func update_stat_labels():
	upgrade_labels.find_node("HP").text = hp_text % Stats.hp_level
	upgrade_labels.find_node("DEF").text = def_text % Stats.def_level
	upgrade_labels.find_node("DMG").text = dmg_text % Stats.dmg_level
	upgrade_labels.find_node("ROF").text = rof_text % Stats.rof_level
	upgrade_labels.find_node("SPD").text = spd_text % Stats.spd_level

func update_stat_level(stat : String):
	upgrade_labels.find_node(stat.to_upper()).text = get(stat + "_text") % Stats.get(stat + "_level")

func _on_HealthBar_mouse_entered():
	healthbar.percent_visible = true

func _on_HealthBar_mouse_exited():
	healthbar.percent_visible = false

func _on_ExpBar_mouse_entered():
	expbar.percent_visible = true

func _on_ExpBar_mouse_exited():
	expbar.percent_visible = false

func _on_HP_pressed():
	emit_signal("stat_level_up", "hp")

func _on_DEF_pressed():
	emit_signal("stat_level_up", "def")

func _on_DMG_pressed():
	emit_signal("stat_level_up", "dmg")

func _on_ROF_pressed():
	emit_signal("stat_level_up", "rof")

func _on_SPD_pressed():
	emit_signal("stat_level_up", "spd")
