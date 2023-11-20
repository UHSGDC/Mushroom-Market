extends PanelContainer

signal switch_pressed

@onready var day_label: Label = $VBoxContainer/ButtonPanel/MarginContainer/VSplitContainer/HBoxContainer/Day/Label
@onready var money_label: Label = $VBoxContainer/ButtonPanel/MarginContainer/VSplitContainer/HBoxContainer/Money/Label
@onready var level_label: Label = $VBoxContainer/ButtonPanel/MarginContainer/VSplitContainer/HBoxContainer/Level/Label



func _ready() -> void:
	Player.day_changed.connect(func(value: int):
		day_label.text = str(value)
	)
	Player.money_changed.connect(func(value: int):
		money_label.text = str(value)
	)
	Player.level_changed.connect(func(value: int):
		level_label.text = str(value)
	)


func _on_switch_pressed() -> void:
	switch_pressed.emit()
