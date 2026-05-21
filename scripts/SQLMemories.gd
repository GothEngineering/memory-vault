extends Control

@onready var title_text: TextEdit = $TitleText
@onready var desc_text: TextEdit = $DescText
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
		"title" : title_text.text,
		"description" : desc_text.text,
		"data_saved" : Time.get_date_string_from_system()
	}

	database.insert_row("memories", data)
	

func _on_read_data_pressed() -> void:
	var read_data = database.select_rows("memories", "", ["*"])

	for old_data in v_box_container.get_children():
		old_data.queue_free()

	for rows in read_data:
		var new_label = Label.new() 
		new_label.text = str(rows["title"]) + ": " + str(rows["description"]) # Add an space or something
		# The title looks too close to the description and it gives me an eye sore
		v_box_container.add_child(new_label)

func _on_update_data_pressed() -> void:
	database.update_rows("memories", "title = '" + title_text.text + "'", {"description": str(desc_text.text)})
	


func _on_delete_data_pressed() -> void:
	database.delete_rows("memories", "title = '" + title_text.text + "'")
	


func _on_custom_select_pressed() -> void:
	pass # Add functionality to this button, i didn't understood what the fuck it does
	# Can't a search bar do the same and better?
