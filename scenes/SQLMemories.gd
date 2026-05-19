extends Control

var database : SQLite

func _ready() -> void:
	database = SQLite.new()
	database.path = "res://memories_data.db"
	database.open_db()
	pass # TO DO: connect the buttons with "button down" signals to the script, as shrimple as that



func _process(delta: float) -> void:
	pass
