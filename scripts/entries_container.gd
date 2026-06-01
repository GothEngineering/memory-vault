extends PanelContainer

@onready var rich_text_label: RichTextLabel = $RichTextLabel

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

func set_rows_text(new_text: String) -> void:
	rich_text_label.text = new_text
