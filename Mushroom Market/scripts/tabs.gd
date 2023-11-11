@tool
extends TabContainer


@export var icons: Texture : 
	set(value):
		icons = value
		shop_icon = AtlasTexture.new()
		shop_icon.atlas = value
		shop_icon.region.size = Vector2(24, 24)
		inventory_icon = shop_icon.duplicate()
		inventory_icon.region.position.y += 24
		profile_icon = inventory_icon.duplicate()
		profile_icon.region.position.y += 24

var shop_icon: AtlasTexture
var inventory_icon: AtlasTexture
var profile_icon: AtlasTexture
	
func set_tabs() -> void:
	set_tab_icon(0, shop_icon)
	set_tab_icon(1, inventory_icon)
	set_tab_icon(2, profile_icon)
	set_tab_title(0, "")
	set_tab_title(1, "")
	set_tab_title(2, "")
	
	
func _ready() -> void:
	set_tabs()
	
	
