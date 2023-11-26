class_name CustomerManager extends Node2D

const MAX_CUSTOMERS := 3

@export_node_path("Marker2D") var customer_start_path
@export var customer_scene: PackedScene

@onready var customer_start: Vector2 = get_node(customer_start_path).global_position


func _ready() -> void:
	_new_customer()

func _on_spawn_trigger_activated(probability: float) -> void:
	if randf() < probability:
		_new_customer()
		
		
func _new_customer() -> void:
	var customer := customer_scene.instantiate()
	add_child(customer)
	customer.global_position = customer_start
