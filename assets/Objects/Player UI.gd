extends CanvasLayer

signal stat_level_up

onready var healthbar := $HealthBar
onready var expbar := $ExpBar
onready var level_label := $Level
onready var stat_label := $UpgradeTab/StatsText
onready var upgrade_bars := $UpgradeTab/HBoxContainer/Bars
onready var upgrade_buttons := $UpgradeTab/HBoxContainer/Buttons
onready var anim_player := $AnimationPlayer

var level_text := "Level: %s"
var stat_text := "Stat points: %s"
export var appeared = false

func update_level_label():
	level_label.text = level_text % str(Stats.level)

func update_stat_points_label():
	stat_label.text = stat_text % Stats.stat_points
	if Stats.stat_points == 0 :
		if appeared: anim_player.play("Disappear")
	elif not appeared: anim_player.play("Appear")

func update_stat_bars():
	upgrade_bars.find_node("HP").value = Stats.hp_level
	upgrade_bars.find_node("DEF").value = Stats.def_level
	upgrade_bars.find_node("DMG").value = Stats.dmg_level
	upgrade_bars.find_node("ROF").value = Stats.rof_level
	upgrade_bars.find_node("SPD").value = Stats.spd_level

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
	upgrade_bars.find_node("HP").value = Stats.hp_level

func _on_DEF_pressed():
	emit_signal("stat_level_up", "def")
	upgrade_bars.find_node("DEF").value = Stats.def_level

func _on_DMG_pressed():
	emit_signal("stat_level_up", "dmg")
	upgrade_bars.find_node("DMG").value = Stats.dmg_level

func _on_ROF_pressed():
	emit_signal("stat_level_up", "rof")
	upgrade_bars.find_node("ROF").value = Stats.rof_level

func _on_SPD_pressed():
	emit_signal("stat_level_up", "spd")
	upgrade_bars.find_node("SPD").value = Stats.spd_level
