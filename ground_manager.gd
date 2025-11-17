extends Node3D

@export var player: Node3D
@export var segment_scene: PackedScene
@export var segment_length = 20
@export var initial_segments = 5

var segments = []

func _ready():
	if not segment_scene:
		push_error("segment_scene n'est pas assigné !")
		return

	for i in range(initial_segments):
		spawn_segment(-i * segment_length)

func _process(delta):
	for segment in segments:
		if not segment:
			continue
		if segment.global_transform.origin.z > player.global_transform.origin.z + segment_length:
			var front_z = get_min_segment_z()  # segment le plus avancé devant le player
			segment.global_transform.origin.z = front_z - segment_length

func spawn_segment(z_pos):
	var segment_instance = segment_scene.instantiate()
	if not segment_instance:
		push_error("Impossible d'instancier le segment !")
		return
	add_child(segment_instance)
	segment_instance.global_transform.origin = Vector3(0, 0, z_pos)
	segments.append(segment_instance)
	spawn_obstacle_on_segment(z_pos)

func get_min_segment_z():
	var min_z = INF
	for s in segments:
		if s:
			min_z = min(min_z, s.global_transform.origin.z)
	return min_z

@export var obstacle_scenes: Array[PackedScene] = []
@export var lanes = [-4, 0, 4]
@export var obstacle_chance = 0.5

func spawn_obstacle_on_segment(segment_z):
	if obstacle_scenes.size() == 0:
		return
	if randf() > obstacle_chance:
		return

	var obstacle_scene = obstacle_scenes[randi() % obstacle_scenes.size()]
	var obstacle_instance = obstacle_scene.instantiate()
	
	var lane_x = lanes[randi() % lanes.size()]
	obstacle_instance.global_transform.origin = Vector3(lane_x, 0, segment_z)
	
	add_child(obstacle_instance)
