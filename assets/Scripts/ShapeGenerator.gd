extends Node2D

onready var square_scene := preload("res://assets/Objects/Square.tscn")
onready var triangle_scene := preload("res://assets/Objects/Triangle.tscn")
onready var spawn_area := $SpawnArea
onready var shapes_node := $Shapes
onready var timer := $SpawnTimer

export var max_shapes : int = 5
export var zero_timer : float = 1.0
export var max_timer : float = 2.0

export(Array, float, 0.0, 1.0, 0.05) var spawn_chances := [0.8, 0.2]
var shape_count := 0 setget set_shape_count

func _ready():
	randomize()
	update_shape_count()

func start_spawn_timer():
	timer.start(lerp(zero_timer, max_timer, shape_count / float(max_shapes)))

func _on_SpawnTimer_timeout():
	var chance_sum = 0;
	for val in spawn_chances:
		chance_sum += val
	var chance := spawn_chances
	for i in range(len(chance)):
		chance[i] /= chance_sum
	var shape_type = randf()
	var shape = null
	if shape_type < spawn_chances[0]:
		shape = square_scene.instance()
	else:
		shape = triangle_scene.instance()
	shape.connect("destroyed", self, "update_shape_count")
	shapes_node.add_child(shape)
	var spawn_center = spawn_area.position
	var spawn_size = spawn_area.get_node("Area").shape.extents
	var spawn_position = spawn_center + Vector2(rand_range(-spawn_size.x, spawn_size.x), rand_range(-spawn_size.y, spawn_size.y))
	shape.position = spawn_position
	shape.rotation_degrees = randi()
	update_shape_count()

func update_shape_count():
	var count = 0
	for shape in shapes_node.get_children():
		if shape.has_meta("is_destroyed") and shape.get_meta("is_destroyed") == false:
			count += 1
	self.shape_count = count

func set_shape_count(value):
	shape_count = value
	if shape_count < max_shapes:
		start_spawn_timer()
