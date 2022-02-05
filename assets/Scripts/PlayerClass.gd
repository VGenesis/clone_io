extends Node2D

const data_dir := "res://assets/Data"

class Class:
	var name : String
	var parent : Class
	var children : Array
	var stat_filename : String
	
	func _init(_name : String, _stat_filename : String):
		self.name = _name
		parent = null
		children = []
		self.stat_filename = _stat_filename
	
	func get_name(): return name
	
	func get_parent(): return parent
	
	func set_parent(_parent : Class): self.parent = _parent
	
	func has_children(): return (children.size() > 0)
	
	func get_child(index : int): return children[index]
	
	func find_child(_name : String):
		if has_children(): for child in children:
			if child.get_name() == _name: return child.get_name()
		return name
	
	func get_children(): return children
	
	func add_child(object : Class):
		children.append(object)
		object.set_parent(self)
	
	func get_filename(): return stat_filename
	
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
			child.print();

var class_hierarchy = null

func _ready():
	class_hierarchy = Class.new("Shooter", "ShooterData.dat")
	class_hierarchy.add_child(Class.new("Shotgunner", "ShotgunnerData.dat"))
	class_hierarchy.add_child(Class.new("Sniper", "SniperData.dat"))

func get_class_data(c : Class):
	var file = File.new()
	var filepath = data_dir + "/" + c.get_filename()
	var data : Dictionary
	
	if file.file_exists(filepath):
		if file.open(filepath, File.READ) == OK:
			data = file.get_var()
			file.close()
	
	return data
