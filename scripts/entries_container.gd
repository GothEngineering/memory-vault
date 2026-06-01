extends PanelContainer

@onready var rich_text_label: RichTextLabel = $RichTextLabel

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

func set_rows_text(new_text: String) -> void:
	rich_text_label.text = new_text

#func _gui_input(event: InputEvent) -> void:
	#if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_LEFT and event.double_click:
			#print("oli toi probando")
