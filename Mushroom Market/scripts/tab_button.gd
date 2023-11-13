@tool
extends PanelContainer


const SELECT_COLOR: Color = Color8(153, 153, 153)
const NORMAL_COLOR: Color = Color8(125, 125, 125)


@export var normal_style: StyleBoxFlat

var hovered: bool = false :
	set(value):
		hovered = value
		style.border_width_top = 4 if value or selected else 12

var selected: bool = false : 
	set(value):
		selected = value
		style.bg_color = SELECT_COLOR if value else NORMAL_COLOR
		style.border_width_top = 4 if value or hovered else 12

@onready var style = normal_style

func _ready() -> void:
	if has_theme_stylebox_override("panel"):
		remove_theme_stylebox_override("panel")
	add_theme_stylebox_override("panel", style)
	get_child(0).mouse_entered.connect(func(): hovered = true)
	get_child(0).mouse_exited.connect(func(): hovered = false)
	
