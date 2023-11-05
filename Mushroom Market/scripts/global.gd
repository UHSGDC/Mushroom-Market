extends Node

signal item_selected(item: Items.ID)
signal shovel_selected
signal day_cycled

var change_inventory_item: Callable
