extends Node

signal money_changed(value)
signal level_changed(value)
signal day_changed(value)

const XP_FOR_FIRST_LEVEL = 20
const LEVEL_MULTIPLIER = 1.1
const MAX_LEVEL = 20

var money: int : 
	set(value):
		money = value
		money_changed.emit(value)
var xp: int = 0
var level: int : 
	set(value):
		level = value
		level_changed.emit(value)
var day: int :
	set(value):
		day = value
		day_changed.emit(value)
		
func _ready() -> void:
	set_deferred("money", 0)
	set_deferred("level", 0)
	set_deferred("day", 0)


func has_funds(price: int) -> bool:
	return money >= price


# Will return true if transaction is successful otherwise false.
func use_funds(price: int) -> bool:
	if !has_funds(price):
		return false

	money -= price
	return true


func increase_xp(add: int) -> void:
	xp += add
	
	if level >= 20:
		return
	
	while xp > XP_FOR_FIRST_LEVEL * pow(LEVEL_MULTIPLIER, level):
		xp -= XP_FOR_FIRST_LEVEL * pow(LEVEL_MULTIPLIER, level)
		level += 1
