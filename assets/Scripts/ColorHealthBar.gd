extends Control

onready var timer := $VisibilityTimer

export var time_visible := 2.5

var value := 1.0 setget set_value

func set_visible(time):
	visible = true
	if time > 0:
		timer.start(time)

func set_value(val):
	value = val
	$HealthBarGreen.rect_scale = Vector2(value, 1)
	if value == 1:
		visible = false
	else: set_visible(time_visible)

func _on_VisibilityTimer_timeout():
	visible = false
