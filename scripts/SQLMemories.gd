extends Control

@onready var title_input: TextEdit = $Panel/TitleInput
@onready var desc_input: TextEdit = $Panel/DescInput
@onready var game_title_input: TextEdit = $Panel/GameTitleInput
@onready var location_input: TextEdit = $Panel/LocationInput
@onready var feeling_input: TextEdit = $Panel/FeelingInput
@onready var scroll_container: ScrollContainer = $ScrollContainer
@onready var v_box_container: VBoxContainer = $ScrollContainer/VBoxContainer


var database : SQLite

func _ready() -> void:
	database = SQLite.new()
	database.path = "res://memories_data.db"
	database.open_db()



func _process(delta: float) -> void:
	pass


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
	

func _on_read_data_pressed() -> void:
	var read_data = database.select_rows("memories", "", ["*"]) # Grabs everything from all the rows,
	# REMEMBER to add a WHERE clause otherwise this will annihilate everything if i have a bunch of rows

	# Cleans up the old data so it doesn't stack onto the new data
	for old_data in v_box_container.get_children():
		old_data.queue_free()

	for rows in read_data:
		var new_label = Label.new() 
		var data_template = "%s / %s / %s / %s / %s / %s" # Template of how the data looks like
		new_label.text = data_template % [
			rows["title"],
			rows["description"],
			rows["game_title"],
			rows["location"],
			rows["feeling"],
			rows["data_saved"],
		]

		#new_label.text = str(rows["title"]) + ": " + str(rows["description"]) # Old method, too many str()
		# and it looks like shit because of that. I was writing it all manually like a dummy

		v_box_container.add_child(new_label)

func _on_update_data_pressed() -> void:
	database.update_rows("memories", "title = '" + title_input.text + "'", {"description": str(desc_input.text)})
	# Remember to add code to update the gametitle, location and feeling columns respectively, it isn't doing
	# anything rn


func _on_delete_data_pressed() -> void:
	database.delete_rows("memories", "title = '" + title_input.text + "'")
	


func _on_custom_select_pressed() -> void:
	pass # Add functionality to this button, i didn't understood what the fuck it does
	# Can't a search bar do the same and better?
