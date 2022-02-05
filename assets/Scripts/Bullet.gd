extends RigidBody2D

onready var timer := $Timer
onready var anim_player := $AnimationPlayer

export var base_scale := 0.15

var start_damage : int
var start_velocity : Vector2
var lifetime : float

var damage : int

func _ready():
	$CollisionShape2D.scale = Vector2(base_scale, base_scale)
	$Sprite.scale = Vector2(base_scale, base_scale)
	$Hurtbox.scale = Vector2(base_scale, base_scale)
	weight = base_scale
	apply_central_impulse(start_velocity)
	damage = start_damage
	timer.start(lifetime)

func _on_Timer_timeout():
	anim_player.play("Destroy")

func _on_Bullet_body_exited(_body):
	damage = linear_velocity.length() / start_velocity.length() * start_damage
	print(damage)
