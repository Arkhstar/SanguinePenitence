class_name Client
extends CharacterBody2D

const SPEED : float = 33.0
@onready var agent : NavigationAgent2D = $NavigationAgent2D

func _ready() -> void:
	agent.path_desired_distance = 4.0
	agent.target_desired_distance = 4.0
	
	_actor_setup.call_deferred()

func _actor_setup() -> void:
	await get_tree().physics_frame
	set_target(global_position)

func set_target(target : Vector2) -> void:
	agent.target_position = target

func _physics_process(_delta: float) -> void:
	if agent.is_navigation_finished():
		velocity = Vector2.ZERO
		return
	
	var cur_pos : Vector2 = global_position
	var next_path : Vector2 = agent.get_next_path_position()
	
	velocity = cur_pos.direction_to(next_path) * SPEED
	move_and_slide()
