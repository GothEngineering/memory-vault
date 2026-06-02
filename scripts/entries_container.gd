extends PanelContainer

@onready var rich_text_label: RichTextLabel = $RichTextLabel

var entry_id : int
signal double_clicked_entry(clicked_id : int)

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func set_rows_text(new_text: String) -> void:
	rich_text_label.text = new_text

func _on_rich_text_label_gui_input(event: InputEvent) -> void:
	var selection = "id = " + str(entry_id)
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.double_click:
			#DB_global.database.select_rows("memories", selection, ["*"])
			double_clicked_entry.emit() # Emit this signal so it triggers the refresh_ui() and it just shows
			# the specific entry (just like that read button). Maybe i'll have to create a new function
			# just for that, for now i'll take a break im exhausted
