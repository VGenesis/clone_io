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

func convert_editor_to_dict():
	var data = {}
	for i in range(2, editor.get_line_count() - 1):
		var line = editor.get_line(i)
		line = line.strip_edges()
		line = line.replace(" = ", "%")
		var words : Array = line.split("%")
		data[words[0]] = words[1]
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
