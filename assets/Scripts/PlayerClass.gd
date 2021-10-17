extends Node2D

const data_dir := "res://assets/Data"

var filenames = {
	"shooter" : "ShooterData.dat",
	"shotgunner" : "ShotgunnerData.dat",
	"sniper" : "SniperData.dat"
}

func _ready():
	var dir = Directory.new()
	if !dir.dir_exists(data_dir):
		dir.make_dir(data_dir)
	var direrror = dir.open(data_dir)
	if direrror == OK:
		var data = shooter_stats.duplicate()
		var file = File.new()
		var error = file.open(dir.get_current_dir() + "/" + filenames.shooter, File.WRITE)
		if error == OK:
			file.store_var(data)
			file.close()
		
		data = shotgunner_stats.duplicate()
		error = file.open(dir.get_current_dir() + "/" + filenames.shotgunner, File.WRITE)
		if error == OK:
			file.store_var(data)
			file.close()
		
		data = sniper_stats.duplicate()
		error = file.open(dir.get_current_dir() + "/" + filenames.sniper, File.WRITE)
		if error == OK:
			file.store_var(data)
			file.close()

var shooter_stats := {
	"name" : "Shooter",
	"hp_per_level" : 5,
	"hp" : [100, 150, 200, 275, 350, 500],
	"armor" : [5, 7, 10, 14, 20, 30],
	"bullet_dmg" : [10, 25, 20, 25, 30, 40],
	"bullet_spd" : [500, 550, 600, 650, 700, 750],
	"bullet_lifetime" : 1.0,
	"bullet_size" : Vector2(0.15, 0.15),
	"bullets_per_shot" : [1, 1],
	"rof" : [2.0, 2.4, 2.8, 3.25, 4.0, 5.0],
	"max_speed" : [200, 230, 260, 300, 350, 400],
	"acceleration" : [500, 600, 700, 850, 1000, 1250],
	"friction" : [0.5, 0.525, 0.55, 0.575, 0.6, 0.65],
	"stat_restriction" : PoolStringArray()
}

var shotgunner_stats := {
	"name" : "Shotgunner",
	"hp_per_level" : 5,
	"hp" : [150, 200, 250, 350, 450, 600],
	"armor" : [15, 20, 25, 30, 40, 60],
	"bullet_dmg" : [14, 18, 23, 30, 40, 55],
	"bullet_spd" : [500, 550, 600, 650, 700, 750],
	"bullet_lifetime" : 0.2,
	"bullet_size" : Vector2(0.1, 0.1),
	"bullets_per_shot" : [4, 8],
	"rof" : [0.8, 0.9, 1.0, 1.1, 1.25, 1.4],
	"max_speed" : [200, 230, 260, 300, 350, 400],
	"acceleration" : [500, 600, 700, 850, 1000, 1250],
	"friction" : [0.5, 0.525, 0.55, 0.575, 0.6, 0.65],
	"stat_restriction" : PoolStringArray()
}

var sniper_stats := {
	"name" : "Sniper",
	"hp_per_level" : 5,
	"hp" : [120, 175, 225, 300, 375, 450],
	"armor" : [3, 5, 8, 12, 16, 20],
	"bullet_dmg" : [40, 60, 90, 120, 160, 225],
	"bullet_spd" : [800, 900, 1050, 1200, 1450, 1700],
	"bullet_lifetime" : 1.2,
	"bullet_size" : Vector2(0.25, 0.25),
	"bullets_per_shot" : [1, 1],
	"rof" : [1.0, 1.1, 1.25, 1.35, 1.5, 1.75],
	"max_speed" : [200, 230, 260, 300, 350, 400],
	"acceleration" : [500, 600, 700, 850, 1000, 1250],
	"friction" : [0.5, 0.525, 0.55, 0.575, 0.6, 0.65],
	"stat_restriction" : PoolStringArray()
}
