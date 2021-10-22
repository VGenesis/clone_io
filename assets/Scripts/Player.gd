extends KinematicBody2D

onready var pivot := $Pivot
onready var shoot_timer := $Timer
onready var bullet_scene := preload("res://assets/Objects/Bullet.tscn")
onready var scene := get_tree().current_scene

export(String, "Shooter", "Shotgunner", "Sniper") onready var classname = "Shooter"

var direction : Vector2 = Vector2.ZERO
var velocity : Vector2 = Vector2.ZERO
var can_shoot : bool = true
var shooting : bool = false
var size : float = 0.25

var class_stats = {}

var hp setget set_health
var max_hp
var armor
var bullet_damage
var bullet_speed
var bullets_per_shot
var bullet_lifetime
var rof
var max_speed
var acceleration
var friction

var shield setget set_shield

func _ready():
	set_class_data(classname)
	
	max_hp = class_stats.hp[Stats.hp_level]
	armor = class_stats.armor[Stats.def_level]
	bullet_damage = class_stats.bullet_dmg[Stats.dmg_level]
	bullet_speed = class_stats.bullet_spd[Stats.dmg_level]
	bullet_lifetime = class_stats.bullet_lifetime
	bullets_per_shot = class_stats.bullets_per_shot
	rof = class_stats.rof[Stats.rof_level]
	max_speed = class_stats.max_speed[Stats.spd_level]
	acceleration = class_stats.acceleration[Stats.spd_level]
	friction = class_stats.friction[Stats.spd_level]
	
	self.hp = max_hp
	self.shield = armor
	
	scale = Vector2(size, size)

func set_class_data(new_classname : String):
	var file = File.new()
	var filepath = PlayerClass.get_class_filepath(new_classname)
	
	if file.file_exists(filepath):
		if file.open(filepath, File.READ) == OK:
			class_stats = file.get_var()
			file.close()
	print(class_stats)

func set_health(value):
	hp = clamp(value, 0, max_hp)
	if hp == 0:
		Stats.player_gui.queue_free()
		queue_free()
	else: Stats.set_ui_hp(hp, max_hp)

func take_damage(damage):
	var shield_damage = min(shield, damage * 0.8)
	var hp_damage = damage - shield_damage
	self.shield -= shield_damage
	hp -= hp_damage

func set_shield(value):
	shield = clamp(value, 0, armor)
	if $ShieldTimer.time_left == 0 and shield < armor:
		$ShieldTimer.start(1.0)
	if shield == 0:
		$ShieldTimer.stop()
		$ShieldTimer.start(3.0)

func _process(_delta):
	pivot.rotation = get_angle_to(get_global_mouse_position())
	if shooting and can_shoot:
		if bullets_per_shot == PoolIntArray([1, 1]):
			create_bullet(Vector2(cos(pivot.rotation), sin(pivot.rotation)))
		if bullets_per_shot[0] != bullets_per_shot[1]:
			var bullets = int(rand_range(bullets_per_shot[0], bullets_per_shot[1]))
			for _i in range(bullets):
				var bdir = Vector2(cos(pivot.rotation), sin(pivot.rotation)) + Vector2(rand_range(-0.1, 0.1), rand_range(-0.1, 0.1))
				create_bullet(bdir)

func create_bullet(bullet_direction : Vector2):
	var bullet = bullet_scene.instance()
	bullet.start_damage = bullet_damage
	bullet.start_velocity = bullet_direction * bullet_speed + 0.2 * velocity
	bullet.lifetime = bullet_lifetime
	bullet.position = position + bullet_direction * 32
	bullet.scale = Vector2(0.2, 0.2)
	scene.add_child(bullet)
	velocity -= bullet.start_velocity * 0.1 * bullet.base_scale
	can_shoot = false
	shoot_timer.start(1/rof)

func _unhandled_input(event):
	if event.is_action_pressed("key_shoot"):
		shooting = true
	if event.is_action_released("key_shoot"):
		shooting = false

func level_up():
	var hppc = hp/max_hp
	max_hp += class_stats.hp_per_level
	hp = lerp(0, max_hp, hppc)

func stat_level_up(stat : String):
	if Stats.stat_points > 0: 
		match(stat):
			"hp":
				Stats.hp_level += 1
				var hppc = hp/max_hp
				max_hp += class_stats.hp[Stats.hp_level] - class_stats.hp[Stats.hp_level - 1]
				hp = lerp(0, max_hp, hppc)
			"def":
				Stats.def_level += 1
				armor = class_stats.armor[Stats.def_level]
			"dmg":
				Stats.dmg_level += 1
				bullet_damage = class_stats.bullet_dmg[Stats.dmg_level]
				bullet_speed = class_stats.bullet_spd[Stats.dmg_level]
			"rof":
				Stats.rof_level += 1
				rof = class_stats.rof[Stats.rof_level]
			"spd":
				Stats.spd_level += 1
				max_speed = class_stats.max_speed[Stats.spd_level]
				acceleration = class_stats.acceleration[Stats.spd_level]
				friction = class_stats.friction[Stats.spd_level]
		Stats.stat_points -= 1

func evolve(new_classname : String):
	var old_class_stats = class_stats.duplicate()
	set_class_data(new_classname)
	
	max_hp = class_stats.hp[Stats.hp_level]
	armor = class_stats.armor[Stats.def_level]
	bullet_damage = class_stats.bullet_dmg[Stats.dmg_level]
	bullet_speed = class_stats.bullet_spd[Stats.dmg_level]
	bullet_lifetime = class_stats.bullet_lifetime
	bullets_per_shot = class_stats.bullets_per_shot
	rof = class_stats.rof[Stats.rof_level]
	max_speed = class_stats.max_speed[Stats.spd_level]
	acceleration = class_stats.acceleration[Stats.spd_level]
	friction = class_stats.friction[Stats.spd_level]
	
	if class_stats.hp_per_level != old_class_stats.hp_per_level:
		max_hp += abs(class_stats.hp_per_level - old_class_stats.hp_per_level) * (Stats.level - 1)
	
	self.hp = max_hp
	self.shield = armor	

func _physics_process(delta):
	direction = Vector2(
		Input.get_action_strength("key_right") - Input.get_action_strength("key_left"),
		Input.get_action_strength("key_down") - Input.get_action_strength("key_up")
	).normalized()
	
	velocity += direction * acceleration * delta;
	velocity = velocity.clamped(max_speed)
	velocity -= velocity * friction * delta
	
	velocity = move_and_slide(velocity)

func _on_Timer_timeout():
	can_shoot = true

func _on_ShieldTimer_timeout():
	shield = armor
