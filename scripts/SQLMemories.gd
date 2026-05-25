extends Control

@onready var title_input: TextEdit = $Panel/TitleInput
@onready var desc_input: TextEdit = $Panel/DescInput
@onready var game_title_input: TextEdit = $Panel/GameTitleInput
@onready var location_input: TextEdit = $Panel/LocationInput
@onready var feeling_input: TextEdit = $Panel/FeelingInput
@onready var id_input: TextEdit = $Panel/IDInput
@onready var scroll_container: ScrollContainer = $ScrollContainer
@onready var v_box_container: VBoxContainer = $ScrollContainer/VBoxContainer


var database : SQLite

func _ready() -> void:
	database = SQLite.new()
	database.path = "res://memories_data.db"
	database.open_db()
	refresh_data_ui()

func _process(delta: float) -> void:
	pass

func refresh_data_ui():
	# This function refreshes the UI whenever i call it, but so far it's so sensitive it triggers
	# upon pressing the button even if it doesn't make sense to do so (like pressing update without doing 
	# any changes)
	var read_data = database.select_rows("memories", "", ["*"])

	for old_row in v_box_container.get_children():
		old_row.queue_free()

	for rows in read_data:
		var new_label = Label.new() 
		var data_template = "%s / %s / %s / %s / %s / %s / %s" # Template of how the data looks like
		#new_label.autowrap_mode = TextServer.AUTOWRAP_WORD 
		new_label.text = data_template % [
			rows["id"],
			rows["title"],
			rows["description"],
			rows["game_title"],
			rows["location"],
			rows["feeling"],
			rows["data_saved"],
		]

		v_box_container.add_child(new_label)

func _on_create_data_pressed() -> void:
	var data = {
		"title" : title_input.text,
		"description" : desc_input.text,
		"game_title" : game_title_input.text,
		"location" : location_input.text,
		"feeling" : feeling_input.text,
		"data_saved" : Time.get_date_string_from_system(),
	}

	database.insert_row("memories", data)
	refresh_data_ui()

func _on_read_data_pressed() -> void:
	# TO DO: make it so that if it does detect a valid id; it just shows that specific row.
	# I suppose i could copy the for loops i made for the function.
	# Right now it's not working
	var input_received = id_input.text
	var read_data = database.select_rows("memories", "id = " + str(id_input.text), ["*"])
	if input_received == "":
		refresh_data_ui()
		print("aki no hai nada asi q imprimire todo")
	else:
		# FUCK YESSS IT WORKSSS IM A BLOODY GENIUS
		for old_row in v_box_container.get_children():
			old_row.queue_free()

		for row in read_data:
			var new_label = Label.new()
			var data_template = "%s / %s / %s / %s / %s / %s / %s"
			new_label.text = data_template % [
			row["id"],
			row["title"],
			row["description"],
			row["game_title"],
			row["location"],
			row["feeling"],
			row["data_saved"],
			]
			v_box_container.add_child(new_label)

		print("aki si hay texto")



	#if input_received == "":
		#database.select_rows("memories", "", ["*"])
	#else:
		#var id_inputted = str(id_input.text)
		#database.select_rows("memories", "id = " + id_inputted, ["*"])
		#for old_row in v_box_container.get_children():
			#old_row.queue_free()

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
	database.update_rows("memories", id_inputted, data_to_update) 
	# What is "SQL error: near ";": syntax error"
	# it occurs when i try to update without an id inside (i mean it makes sense i suppose)
	refresh_data_ui()

func _on_delete_data_pressed() -> void:
	# I think that fixed it; probably
	database.delete_rows("memories", "id = '" + id_input.text + "'")
	
	refresh_data_ui()


func _on_custom_select_pressed() -> void:
	pass # Still pretty useless 
