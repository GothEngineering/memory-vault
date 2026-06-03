extends Control

@onready var title_input: TextEdit = $Panel/TitleInput
@onready var desc_input: TextEdit = $Panel/DescInput
@onready var game_title_input: TextEdit = $Panel/GameTitleInput
@onready var location_input: TextEdit = $Panel/LocationInput
@onready var feeling_input: TextEdit = $Panel/FeelingInput
@onready var id_input: TextEdit = $Panel/IDInput
@onready var scroll_container: ScrollContainer = $ScrollContainer
@onready var v_box_container: VBoxContainer = $ScrollContainer/VBoxContainer # I gotta change this name

const ENTRIESCONTAINER = preload("res://scenes/entries_container.tscn")

#var database : SQLite
var current_offset = 0
var current_limit = 20
var sort_by_oldest = false

func _ready() -> void:
	#database = SQLite.new()
	#database.path = "res://memories_data.db"
	#database.open_db()
	refresh_data_ui()

func _process(delta: float) -> void:
	pass

func delete_old_labels():
	for old_row in v_box_container.get_children():
		old_row.queue_free()

func refresh_data_ui():

	# This function refreshes the UI whenever i call it
	# Refactor this true/false toggle later, it's real bad but funny
	if sort_by_oldest == false: 
		var query_limit = "SELECT * FROM memories ORDER BY id DESC LIMIT %d OFFSET %d;" % [current_limit, current_offset]
		DB_global.database.query(query_limit)
	else:
		var query_limit = "SELECT * FROM memories ORDER BY id ASC LIMIT %d OFFSET %d;" % [current_limit, current_offset]
		DB_global.database.query(query_limit)
	var read_result = DB_global.database.query_result

	# This loop deletes the old labels
	for old_row in v_box_container.get_children():
		old_row.queue_free()

	# This loop creates all the new labels
	for rows in read_result:
		var new_label = ENTRIESCONTAINER.instantiate()
		new_label.entry_id = rows["id"]
		new_label.double_clicked_entry.connect(_clicked_entry_signal)
		var template = "%s | %s | %s"
		var data_on_template = template % [
			rows["id"],
			rows["title"],
			rows["description"],
			#rows["game_title"],
			#rows["location"],
			#rows["feeling"],
			#rows["data_saved"],
		]

		v_box_container.add_child(new_label)
		new_label.set_rows_text(data_on_template)

func _clicked_entry_signal(selection):
	print("oli doble click, mi data es :" + selection)
	var show_selected = DB_global.database.select_rows("memories", "id =" + selection, ["*"])
	delete_old_labels()

	for rows in show_selected:
		var new_label = ENTRIESCONTAINER.instantiate()
		new_label.entry_id = rows["id"]
		var template = "%s | %s | %s | %s | %s | %s | %s"
		var data_on_template = template % [
			rows["id"],
			rows["title"],
			rows["description"],
			rows["game_title"],
			rows["location"],
			rows["feeling"],
			rows["data_saved"],
		]

		v_box_container.add_child(new_label)
		new_label.set_rows_text(data_on_template)

func _on_create_data_pressed() -> void:
	var data = {
		"title" : title_input.text,
		"description" : desc_input.text,
		"game_title" : game_title_input.text,
		"location" : location_input.text,
		"feeling" : feeling_input.text,
		"data_saved" : Time.get_date_string_from_system(),
	}

	DB_global.database.insert_row("memories", data)
	refresh_data_ui()

func _on_read_data_pressed() -> void:

	var input_received = id_input.text
	var read_data = DB_global.database.select_rows("memories", "id = " + str(id_input.text), ["*"])

	# Find a way to search for title if the id isn't full, maybe i have to re-do this part
	if input_received == "":
		refresh_data_ui()
		print("aki no hai nada asi q imprimire todo")
	else:
		delete_old_labels()

	for rows in read_data:
		var new_label = ENTRIESCONTAINER.instantiate()
		new_label.entry_id = rows["id"]
		var template = "%s | %s | %s | %s | %s | %s | %s"
		var data_on_template = template % [
			rows["id"],
			rows["title"],
			rows["description"],
			rows["game_title"],
			rows["location"],
			rows["feeling"],
			rows["data_saved"],
		]

		v_box_container.add_child(new_label)
		new_label.set_rows_text(data_on_template)

		print("aki si hay texto")

func _on_update_data_pressed() -> void:

	# NEVER forget the .text after calling the textedit, PLEASE
	var data_to_update = {
		"title" : title_input.text,
		"description" : desc_input.text,
		"game_title" : game_title_input.text,
		"location" : location_input.text,
		"feeling" : feeling_input.text,
		}
	var id_inputted = "id = " + str(id_input.text)
	DB_global.database.update_rows("memories", id_inputted, data_to_update) 
	# What is "SQL error: near ";": syntax error"
	# it occurs when i try to update without an id inside (i mean it makes sense i suppose)
	refresh_data_ui()

func _on_delete_data_pressed() -> void:

	DB_global.database.delete_rows("memories", "id = '" + id_input.text + "'")
	refresh_data_ui()


func _on_custom_select_pressed() -> void:
	pass 

	# TO-DO: change the current_offset so it hides the last 20 entries to avoid lag
func _on_show_less_pressed() -> void:
	current_offset -= 20
	if current_offset < 0:
		current_offset = 0
	refresh_data_ui()

func _on_show_more_pressed() -> void:
	current_offset += 20
	refresh_data_ui()

func _on_sort_by_pressed() -> void:
	sort_by_oldest = !sort_by_oldest
	refresh_data_ui()
	print("Switched order")
