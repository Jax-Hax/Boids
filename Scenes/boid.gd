extends Node2D
@onready
var screensize = get_viewport().size
var boids = []
var dx = 0;
var dy = 0;
var num_neighbors = 0;
@onready
var area = $Area2D

@export var centering_factor := 0.005
@export var min_distance := 20
@export var avoid_factor := 0.05
@export var velocity_match_factor := 0.05
@export var edge_margin := 200
@export var turn_factor := 1
@export_range (0.1, 10.0) var rotate_speed := 4.0
@export var speed_limit := 15

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	boids = area.get_overlapping_areas()
	if (len(boids) > 0):
		num_neighbors = len(boids)
		fly_towards_center()
		avoid_others()
		match_velocity()
		limit_speed()
		avoid_edges()
	var angle = global_position.direction_to(Vector2(position.x + dx, position.y + dy)).angle() + PI
	global_rotation = move_toward(global_rotation,angle,delta*rotate_speed)
	position.x += dx
	position.y += dy

# Find the center of mass of the other boids and adjust velocity slightly to point towards the center of mass.
func fly_towards_center():
	var center_x = 0;
	var center_y = 0;
	for boid in boids:
		center_x += boid.get_parent().global_position.x
		center_y += boid.get_parent().global_position.y
	center_x /= num_neighbors
	center_y /= num_neighbors
	dx += (center_x - position.x) * centering_factor
	dy += (center_y - position.y) * centering_factor

func avoid_others():
	var move_x = 0;
	var move_y = 0;
	for boid in boids:
		if (position.distance_to(boid.get_parent().global_position) < min_distance):
			move_x += position.x - boid.get_parent().global_position.x
			move_y += position.y - boid.get_parent().global_position.y
	dx += move_x * avoid_factor
	dy += move_y * avoid_factor

func match_velocity():
	var avg_dx = 0;
	var avg_dy = 0;
	for boid in boids:
		avg_dx += boid.get_parent().dx;
		avg_dy += boid.get_parent().dy;
	avg_dx /= num_neighbors;
	avg_dy /= num_neighbors;
	dx += (avg_dx - dx) * velocity_match_factor;
	dy += (avg_dy - dy) * velocity_match_factor;

func avoid_edges():
	if (position.x < edge_margin):
		dx += turn_factor
	if (position.x > screensize.x - edge_margin):
		dx -= turn_factor
	if (position.y < edge_margin):
		dy += turn_factor
	if (position.y > screensize.y - edge_margin):
		dy -= turn_factor

func limit_speed():
	var speed = sqrt(dx**2 + dy**2);
	if (speed > speed_limit):
		dx = (dx/speed) * speed_limit
		dy = (dy/speed) * speed_limit