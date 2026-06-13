extends PanelContainer

@onready var rich_text_label: RichTextLabel = $RichTextLabel

var entry_id : int
signal double_clicked_entry(selection : int)

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

# Creation of the entries that get added to the entries container
func set_rows_text(new_text: String) -> void:
	rich_text_label.text = new_text

# Function to get the ID of the current doubleclicked entry to send a signal to the UI
func _on_rich_text_label_gui_input(event: InputEvent) -> void:
	var selection = str(entry_id)
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.double_click:
			double_clicked_entry.emit(selection)
