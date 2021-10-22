extends RigidBody2D

signal destroyed

onready var hpbar := $HealthBar
onready var animplayer := $AnimationPlayer

export(int, 10, 200, 5) var max_hp = 50
export(float, 0, 1.0, 0.05) var start_size := 0.2
export(int, 10, 200, 5) var xp = 10

var hp setget set_hp
export var size_scale = 1.0 setget resize

func _ready():
	self.hp = max_hp
	$Sprite.scale = Vector2(start_size, start_size)
	$Body.scale = Vector2(start_size, start_size)
	$Hitbox.scale = Vector2(start_size, start_size)
	hpbar.rect_position.y *= start_size
	var bar_size = hpbar.get_node("HealthBarGreen").rect_size * start_size
	hpbar.get_node("HealthBarGreen").set_size(bar_size)
	hpbar.get_node("HealthBarGreen").rect_position = Vector2.ZERO - bar_size / 2
	hpbar.get_node("HealthBarRed").set_size(bar_size)
	hpbar.get_node("HealthBarRed").rect_position = Vector2.ZERO - bar_size / 2
	set_meta("is_destroyed", false)
	animplayer.play("Create")

func set_hp(value):
	hp = value
	if hp <= 0:
		Stats.xp += xp
		set_meta("is_destroyed", true)
		emit_signal("destroyed")
		animplayer.play("Destroy")
	else: 
		hpbar.value = float(hp) / max_hp
		if animplayer.current_animation == "":
			animplayer.play("Hit")

func resize(relative_value : float):
	size_scale = start_size * relative_value
	$Sprite.scale = Vector2(size_scale, size_scale)

func _on_Hitbox_area_entered(area):
	self.hp -= area.get_parent().damage
