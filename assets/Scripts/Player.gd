extends KinematicBody2D

onready var pivot := $Pivot
onready var shoot_timer := $Timer
onready var bullet_scene := preload("res://assets/Objects/Bullet.tscn")
onready var scene := get_tree().current_scene

var direction : Vector2 = Vector2.ZERO
var velocity : Vector2 = Vector2.ZERO
var can_shoot : bool = true
var shooting : bool = false
var size : float = 0.25

var hp setget set_health
var max_hp
var armor
var bullet_damage
var bullet_speed
var bullet_lifetime = 1.0
var rof
var max_speed
var acceleration
var friction

func _ready():
	scale = Vector2(size, size)
	hp = Stats.hp_upgrade[Stats.hp_level]
	max_hp = Stats.hp_upgrade[Stats.hp_level]
	armor = Stats.armor_upgrade[Stats.def_level]
	bullet_damage = Stats.bullet_damage_upgrade[Stats.dmg_level]
	bullet_speed = Stats.bullet_speed_upgrade[Stats.dmg_level]
	rof = Stats.rof_base * Stats.rof_upgrade[Stats.rof_level]
	max_speed = Stats.spd_max_speed_upgrade[Stats.spd_level]
	acceleration = Stats.spd_acceleration_upgrade[Stats.spd_level]
	friction = Stats.spd_friction_upgrade[Stats.spd_level]
	
	Stats.set_ui_hp(hp, max_hp)

func set_health(value):
	hp = clamp(value, 0, max_hp)
	if hp == 0:
		Stats.player_gui.queue_free()
		queue_free()
	else: Stats.set_ui_hp(hp, max_hp)

func _process(delta):
	pivot.rotation = get_angle_to(get_global_mouse_position())
	if shooting and can_shoot:
		var bullet = bullet_scene.instance()
		bullet.start_damage = bullet_damage
		bullet.start_velocity = Vector2(cos(pivot.rotation), sin(pivot.rotation)) * bullet_speed + 0.2 * velocity
		bullet.lifetime = bullet_lifetime
		bullet.position = position + Vector2(cos(pivot.rotation), sin(pivot.rotation)) * 32
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

func stat_level_up(stat : String):
	if Stats.stat_points > 0: 
		match(stat):
			"hp":
				Stats.hp_level += 1
				var hppc = hp/max_hp
				max_hp += Stats.hp_upgrade[Stats.hp_level] - Stats.hp_upgrade[Stats.hp_level - 1]
				hp = lerp(0, max_hp, hppc)
			"def":
				Stats.def_level += 1
				armor = Stats.armor_upgrade[Stats.def_level]
			"dmg":
				Stats.dmg_level += 1
				bullet_damage = Stats.bullet_damage_upgrade[Stats.dmg_level]
				bullet_speed = Stats.bullet_speed_upgrade[Stats.dmg_level]
			"rof":
				Stats.rof_level += 1
				rof = Stats.rof_base * Stats.rof_upgrade[Stats.rof_level]
			"spd":
				Stats.spd_level += 1
				max_speed = Stats.spd_max_speed_upgrade[Stats.spd_level]
				acceleration = Stats.spd_acceleration_upgrade[Stats.spd_level]
				friction = Stats.spd_friction_upgrade[Stats.spd_level]
		Stats.stat_points -= 1

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
