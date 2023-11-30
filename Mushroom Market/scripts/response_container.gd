class_name ResponseContainer extends VBoxContainer

signal response_selected(text: String)

@export var response_button_scene: PackedScene

func initialize(response_text_array: PackedStringArray) -> void:
	for text in response_text_array:
		var response_button: Button = response_button_scene.instantiate()
		add_child(response_button)
		response_button.text = text
		response_button.pressed.connect(_on_response_selected.bind(text))

	
func _on_response_selected(text: String) -> void:
	response_selected.emit(text)
	for child in get_children():
		child.queue_free()
