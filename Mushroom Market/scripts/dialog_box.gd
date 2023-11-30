class_name DialogBox extends MarginContainer

signal advance

const TEXT_DELAY = 1 / 30.0

var dialog_playing: bool = false
var waiting_for_next: bool = false

@onready var next_icon := $Control/DialogPanel/NextIcon
@onready var text_output: Label = $Control/DialogPanel/TextOutput
@onready var response_container: ResponseContainer = $Control/ResponseContainer
@onready var speaker_name: Label = $Control/SpeakerName/Label

func _ready() -> void:
	Global.play_dialog = play_dialog
	next_icon.hide()
	
# Make next icon work
func play_dialog(speaker: String, text: String, responses: PackedStringArray = []) -> String:	
	var output: String = ""

	speaker_name.text = speaker
	text_output.text = ""
	
	show()
	dialog_playing = true
	
	await output_text(text, TEXT_DELAY)
	if !responses.is_empty():
		output = await output_question(responses)
	else:
		await advance
	
	
	dialog_playing = false
	hide()
	return output	


func output_question(responses: PackedStringArray) -> String:	
	response_container.initialize(responses)
	return await response_container.response_selected


func output_text(text: String, delay: float) -> void:
	text_output.text = ""
	for character in text:
		text_output.text += character
		await get_tree().create_timer(delay).timeout


func _input(event: InputEvent) -> void:
	if !dialog_playing:
		return
	
	if waiting_for_next and event.is_action_pressed("advance_dialog"):
		waiting_for_next = false
		advance.emit()
		get_tree().set_input_as_handled()
