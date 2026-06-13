extends Node

var database : SQLite
var db_path = "user://memories_data.db"

func _ready() -> void:
	database = SQLite.new()
	database.path = db_path
	if not FileAccess.file_exists(db_path):
		database.open_db()
		create_the_tables()
	else:
		database.open_db()

func create_the_tables():
	var tables = {
		"id" : {"data_type":"int", "primary_key": true, "not_null": true, "auto_increment": true},
		"title" : {"data_type":"text"},
		"description" : {"data_type":"text"},
		"game_title" : {"data_type":"text"},
		"location" : {"data_type":"text"},
		"feeling" : {"data_type":"text"},
		"data_saved" : {"data_type":"text"}
	}
	database.create_table("memories", tables)


func _process(delta: float) -> void:
	pass
