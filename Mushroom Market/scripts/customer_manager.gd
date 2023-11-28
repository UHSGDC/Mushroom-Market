class_name CustomerManager extends Node2D

const MAX_CUSTOMERS := 3
const NAMES: Array[String] = ["Nick", "McGuffrey", "Boat", "John", "Jack", "Jake"]
const CUSTOMER_SPEED := 30.0
const CUSTOMER_HOP_INTERVAL := 0.6
const CUSTOMER_HOP_HEIGHT := 3.0
const CAECILIAN_INTERVAL_MULTIPLIER := 0.5


@export_node_path("Marker2D") var customer_start_path
@export var customer_scene: PackedScene

var available_names: Array[String]

@onready var customer_start: Vector2 = get_node(customer_start_path).global_position


func _ready() -> void:
	_new_customer()
	
func _process(delta: float) -> void:
	_move_customer(get_child(0), delta)

func _on_spawn_trigger_activated(probability: float) -> void:
	if randf() < probability:
		_new_customer()
		
		
func _new_customer() -> void:
	var customer := customer_scene.instantiate()
	add_child(customer)
	customer.global_position = customer_start
	customer.initialize(_get_random_name())


func _get_random_name() -> String:
	if available_names.is_empty():
		available_names = NAMES.duplicate()
	available_names.shuffle()
	return available_names.pop_back()


# Meant to be used inside process or physics_process
func _move_customer(customer: Customer, delta: float) -> void:
	customer.position.x += delta * CUSTOMER_SPEED
	match customer.species:
		Customer.Species.AXOLOTL:
			customer.global_position.y = customer_start.y + sin(customer.position.x * CUSTOMER_HOP_INTERVAL) * CUSTOMER_HOP_HEIGHT
		Customer.Species.TOAD:
			customer.global_position.y = customer_start.y + abs(sin(customer.position.x * CUSTOMER_HOP_INTERVAL)) * CUSTOMER_HOP_HEIGHT
		Customer.Species.CAECILIAN:
			customer.global_position.y = customer_start.y + sin(customer.position.x * CUSTOMER_HOP_INTERVAL * CAECILIAN_INTERVAL_MULTIPLIER) * CUSTOMER_HOP_HEIGHT
