extends Control

@onready var title_input: TextEdit = $Panel/TitleInput
@onready var desc_input: TextEdit = $Panel/DescInput
@onready var game_title_input: TextEdit = $Panel/GameTitleInput
@onready var location_input: TextEdit = $Panel/LocationInput
@onready var feeling_input: TextEdit = $Panel/FeelingInput
@onready var entry_sorter: VBoxContainer = $EntriesContainer/EntrySorter

var current_offset = 0
var current_limit = 20
var sort_by_oldest = false
var sorting_by = "DESC"

const ENTRIESCONTAINER = preload("res://scenes/entries_container.tscn")

func _ready() -> void:
	refresh_data_ui() 


func _process(delta: float) -> void:
	pass

func refresh_data_ui():
	var query_limit = "SELECT * FROM memories ORDER BY id %s LIMIT %d OFFSET %d;" % [sorting_by, current_limit, current_offset]
	DB_global.database.query(query_limit)
	
	var read_result = DB_global.database.query_result

	delete_old_entries()

	for rows in read_result:
		var new_label = ENTRIESCONTAINER.instantiate()
		new_label.entry_id = rows["id"]
		new_label.double_clicked_entry.connect(_clicked_entry_signal)
		var template = "<%s>  [color=yellow]%s[/color]: %s"
		var data_template = template % [
			rows["id"],
			rows["title"],
			rows["description"],
		]

		entry_sorter.add_child(new_label)
		new_label.set_rows_text(data_template)

func _clicked_entry_signal(selection):
	print("oli toi probando " + selection)
	var show_selected = DB_global.database.select_rows("memories", "id =" + selection, ["*"])
	delete_old_entries()

	for rows in show_selected:
		var new_label = ENTRIESCONTAINER.instantiate()
		new_label.entry_id = rows["id"]
		var template = "<%s>  [color=yellow]%s[/color]: %s | %s | %s | %s | %s"
		var data_on_template = template % [
			rows["id"],
			rows["title"],
			rows["description"],
			rows["game_title"],
			rows["location"],
			rows["feeling"],
			rows["data_saved"],
		]

		entry_sorter.add_child(new_label)
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
	var input_received = title_input.text
	var read_data = DB_global.database.select_rows("memories", "title =" + str(input_received), ["*"])

	if input_received == "":
		refresh_data_ui()
		print("nada aqui")
	else:
		delete_old_entries()
		
		for rows in read_data:
			var new_label = ENTRIESCONTAINER.instantiate()
			new_label.entry_id = rows["id"]
			var template = "<%s>  [color=yellow]%s[/color]: %s | %s | %s | %s | %s"
			var data_on_template = template % [
				rows["id"],
				rows["title"],
				rows["description"],
				rows["game_title"],
				rows["location"],
				rows["feeling"],
				rows["data_saved"],
			]

			entry_sorter.add_child(new_label)
			new_label.set_rows_text(data_on_template)

func _on_update_data_pressed() -> void:
	var data_to_update = {
		"title" : title_input.text,
		"description" : desc_input.text,
		"game_title" : game_title_input.text,
		"location" : location_input.text,
		"feeling" : feeling_input.text,
		}

	var title_inputted = "title =" + str(title_input.text)
	DB_global.database.update_rows("memories", "title =" + title_inputted, data_to_update)
	refresh_data_ui()


func _on_delete_data_pressed() -> void:
	DB_global.database.delete_rows("memories", "title = '" + title_input.text + "'")
	refresh_data_ui()

func _on_custom_select_pressed() -> void:
	pass 

func delete_old_entries():
	for old_row in entry_sorter.get_children():
		old_row.queue_free()


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
	if sort_by_oldest == true:
		sorting_by = "ASC"
	else:
		sorting_by = "DESC"
	refresh_data_ui()
