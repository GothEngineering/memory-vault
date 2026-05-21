extends Control

@onready var title_text: TextEdit = $TitleText
@onready var desc_text: TextEdit = $DescText

var database : SQLite

func _ready() -> void:
	database = SQLite.new()
	database.path = "res://memories_data.db"
	database.open_db()
	pass # TO DO: connect the delete data button and the custom select button


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
	print(database.select_rows("memories", "", ["*"]))
	

func _on_update_data_pressed() -> void:
	database.update_rows("memories", "title = '" + title_text.text + "'", {"description": str(desc_text.text)})
	


func _on_delete_data_pressed() -> void:
	database.delete_rows("memories", "title = '" + title_text.text + "'")
	


func _on_custom_select_pressed() -> void:
	pass # Add functionality to this button, i didn't understood what the fuck it does
	# Can't a search bar do the same and better?
