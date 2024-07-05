extends Node

var boid : PackedScene = preload("res://Scenes/boid.tscn")
var rng = RandomNumberGenerator.new()
@export var amount_boids := 100; 
# Called when the node enters the scene tree for the first time.
func _ready():
	var screensize = get_viewport().size
	for i in range(amount_boids):
		var instance = boid.instantiate()
		instance.global_position.x = rng.randf_range(0, screensize.x)
		instance.global_position.y = rng.randf_range(0, screensize.y)
		instance.dx = rng.randf_range(1, 5)
		instance.dy = rng.randf_range(1, 5)
		instance.global_rotation = rng.randf_range(0, 360)
		add_child(instance)
