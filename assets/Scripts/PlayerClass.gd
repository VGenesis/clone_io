extends Node2D

class PlayerClass:
	var name
	var base_hp_increment
	var base_hp_upgrade
	var base_def_upgrade
	var base_bullet_damage_upgrade
	var base_bullet_speed_upgrade
	var base_rof_upgrade
	var base_max_speed_upgrade
	var base_acceleration_upgrade
	var base_friction_upgrade
	var stat_restriction
	var bullets_per_shot

var shooter_stats := [
	"Shooter", 5,									# name and base hp upgrade
	[100, 150, 200, 275, 350, 500],					# health
	[5, 7, 10, 14, 20, 30],							# defense
	[15, 20, 25, 35, 45, 60],						# bullet damage
	[500, 550, 600, 675, 750, 900],					# bullet speed
	[1, 1],											# bullets per shot
	[1.0, 1.1, 1.2, 1.35, 1.5, 1.75],				# rate of fire
	[200, 230, 260, 300, 350, 400],					# max speed
	[500, 600, 700, 850, 1000, 1250],				# acceleration
	[0.5, 0.525, 0.55, 0.575, 0.6, 0.65],			# friction
	[]												# stat restrictions
]

var shotgunner_stats := [
	"Shotgunner", 5,								# name and base hp upgrade
	[150, 200, 250, 350, 450, 600],					# health
	[10, 14, 19, 25, 35, 50],						# defense
	[4, 7, 10, 14, 18, 25],							# bullet damage
	[300, 340, 380, 430, 480, 550],					# bullet speed
	[4, 8],											# bullets per shot
	[0.4, 0.45, 0.5, 0.55, 0.65, 0.75],				# rate of fire
	[200, 230, 260, 300, 350, 400],					# max speed
	[500, 600, 700, 850, 1000, 1250],				# acceleration
	[0.5, 0.525, 0.55, 0.575, 0.6, 0.65],			# friction
	[]												# stat restrictions
]

var sniper_stats := [
	"Sniper", 5,									# name and base hp upgrade
	[120, 175, 225, 300, 375, 450],					# health
	[3, 5, 8, 12, 16, 20],							# defense
	[20, 30, 45, 70, 100, 140],						# bullet damage
	[300, 340, 380, 430, 480, 550],					# bullet speed
	[1, 1],											# bullets per shot
	[0.4, 0.45, 0.5, 0.55, 0.65, 0.75],				# rate of fire
	[200, 230, 260, 300, 350, 400],					# max speed
	[500, 600, 700, 850, 1000, 1250],				# acceleration
	[0.5, 0.525, 0.55, 0.575, 0.6, 0.65],			# friction
	[]												# stat restrictions
]
