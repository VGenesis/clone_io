extends Node2D

onready var editor := $HBoxContainer/VBoxContainer/TextEdit
onready var load_menu := $LoadPopup
onready var save_menu := $SavePopup
onready var confirm_dialog := $SaveDialog
onready var save_changes_dialog := $SaveChangesDialog

const dir_path := "res://assets/Data/"
const editor_text := "  File: %s\n\n%s"

var file_loaded = "" setget set_file_loaded
var text_changed = false

var dict_format = {
	"name" : "String",
	"hp_per_level" : "Int",
	"hp" : "IntArray",
	"armor" : "IntArray",
	"bullet_dmg" : "IntArray",
	"bullet_spd" : "FloatArray",
	"bullet_lifetime" : "Float",
	"bullet_size" : "Vector2",
	"bullets_per_shot" : "IntArray",
	"rof" : "FloatArray",
	"max_speed" : "FloatArray",
	"acceleration" : "FloatArray",
	"friction" : "FloatArray",
	"stat_restriction" : "StringArray",
	"parent_class" : "StringArray",
	"child_classes" : "StringArray"
}

func _ready():
	load_menu.current_dir = dir_path
	save_menu.current_dir = dir_path
	save_changes_dialog.add_button("No", true, "ExitNoSave")
	save_changes_dialog.add_button("Don't exit", true, "NoExit")

func set_file_loaded(value):
	file_loaded = value
	text_changed = false
	if file_loaded != "":
		load_file(file_loaded)
	else:
		editor.text = ""

func split_data_line(arr : String):
	arr = arr.replace("[", "")
	arr = arr.replace("]", "")
	var res = PoolStringArray(arr.split(", "))
	print(res)
	return res

func convert_editor_to_dict():
	var data = {}
	for i in range(2, editor.get_line_count() - 1):
		var line = editor.get_line(i)
		line = line.strip_edges()
		line = line.replace(" = ", "%")
		var words : Array = line.split("%")
		var name = words[0]
		var type = dict_format[name]
		var res
		print(words[0] + " : " + type)
		match(type):
			"Int":   
				res = words[1].to_int()
			"Float": 
				res = words[1].to_float()
			"String":
				res = words[1]
			"IntArray":
				words[1] = split_data_line(words[1])
				res = PoolIntArray()
				for word in words[1]:
					res.append(word.to_int())
			"FloatArray":
				words[1] = split_data_line(words[1])
				res = PoolRealArray()
				for word in words[1]:
					res.append(word.to_float())
			"StringArray":
				words[1] = split_data_line(words[1])
				res = PoolStringArray()
				for word in words[1]:
					res.append(word)
			"Vector2":
				words[1] = split_data_line(words[1])
				res = Vector2(words[1][0], words[1][1])
			"String":
				res = words
		data[name] = res
	return data

func load_file(path):
	var file = File.new()
	if file.open(path, File.READ) == OK:
		var raw_data = file.get_var()
		var data = ""
		for key in raw_data:
			data += "    " + str(key) + " = " + str(raw_data[key]) + "\n"
		editor.text = editor_text % [file_loaded, data]
		file.close()
	convert_editor_to_dict()

func save_file(path):
	var file = File.new()
	if file.open(path, File.WRITE) == OK:
		var data = convert_editor_to_dict()
		file.store_var(data)
		file.close()

func _on_LoadPopup_file_selected(path):
	self.file_loaded = path

func _on_SavePopup_file_selected(path):
	save_file(path)

func _on_SaveDialog_confirmed():
	save_file(file_loaded)

func _on_SaveButton_pressed():
	confirm_dialog.popup_centered()

func _on_SaveAsButton_pressed():
	save_menu.popup_centered()

func _on_LoadButton_pressed():
	load_menu.popup_centered()

func _on_CloseButton_pressed():
	if text_changed: save_changes_dialog.popup_centered()
	else: self.file_loaded = ""

func _on_TextEdit_text_changed():
	text_changed = true

func _on_SaveChangesDialog_custom_action(action):
	match(action):
		"NoExit":
			save_changes_dialog.hide()
		"ExitNoSave":
			self.file_loaded = ""
			save_changes_dialog.hide()

func _on_ExitButton_pressed():
	get_tree().quit()
