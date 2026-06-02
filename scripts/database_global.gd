extends Node

var database : SQLite

func _ready() -> void:
	database = SQLite.new()
	database.path = "res://memories_data.db"
	database.open_db()


func _process(delta: float) -> void:
	pass
