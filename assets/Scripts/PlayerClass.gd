extends Node2D

const data_dir := "res://assets/Data"

class Class:
	var name : String
	var parent : Class
	var children : Array
	var stat_filename : String
	
	func _init(name : String, stat_filename : String):
		self.name = name
		parent = null
		children = []
		self.stat_filename = stat_filename
	
	func get_name(): return name
	
	func get_parent(): return parent
	
	func set_parent(parent : Class): self.parent = parent
	
	func has_children(): return (children.size() > 0)
	
	func get_child(index : int): return children[index]
	
	func get_children(): return children
	
	func add_child(object : Class):
		children.append(object)
		object.set_parent(self)
	
	func get_filename(): return stat_filename
	
	func find_filename(classname : String):
		var filename = ""
		var obj = find_class(classname)
		if obj != null:
			filename = obj.get_filename()
		return filename
	
	func find_class(classname : String):
		if name == classname:
			return self
		else:
			var _class = null
			if(has_children()): for child in children:
				_class = child.find_class(classname)
			return _class
	
	func print():
		print(name)
		if has_children(): for child in children:
			print(child.get_filename())
		

var shooter := Class.new("Shooter", "ShooterData.dat")
var shotgunner := Class.new("Shotgunner", "ShotgunnerData.dat")
var sniper := Class.new("Sniper", "SniperData.dat")

var class_hierarchy := shooter

func _ready():
	class_hierarchy.add_child(shotgunner)
	class_hierarchy.add_child(sniper)

func store_data(data, filepath):
	var file = File.new()
	if file.open(filepath, File.WRITE) == OK:
		file.store_var(data)
		file.close()

func get_class_filepath(classname : String):
	var filepath = data_dir + "/" + class_hierarchy.find_filename(classname)
	return filepath
