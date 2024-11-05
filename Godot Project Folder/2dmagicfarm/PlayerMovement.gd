extends Node2D

@onready var player: CharacterBody2D = $"."  # Reference to the player character body 2D node

# Enum for animation states
enum AnimationState {
	NORTH_EAST,
	NORTH_WEST,
	SOUTH_EAST,
	SOUTH_WEST,
	STOPPED
}

var current_animation: AnimationState = AnimationState.STOPPED
@onready var animator: AnimatedSprite2D = $AnimatedSprite2D
@onready var tile_control: Control = $"../UI_Control"

var can_move: bool = true
var is_valid_tile: bool = false

# Export player movement speed and other variables
@export var speed: float = 200.0
var target_position: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Make sure the initial target position is the player's current position
	target_position = player.position

func _process(_delta: float) -> void:
	if tile_control._is_Valid_tile(target_position):
		is_valid_tile = true
	else:
		is_valid_tile = false
	
	if can_move and player.position.distance_to(target_position) > 1 and is_valid_tile:
		move_player(_delta)
	elif(can_move and is_valid_tile):
		player.position = target_position

func _toggle_Can_Move() -> void:
	can_move = !can_move
	
func _check_can_move() -> bool:
	return can_move  # Simplified return statement

func _input(event):
	if event is InputEventMouseButton and event.pressed and can_move:
		target_position = get_global_mouse_position()  # Update target position on mouse click

# Move the player towards the target position
func move_player(_delta: float) -> void:
	if player.position.distance_to(target_position) > 1:
		var direction = (target_position - player.position).normalized()
		var movement = direction * speed * _delta
		
		# Set the velocity and call move_and_slide
		player.velocity = movement
		player.move_and_slide()
		
		update_animation(direction)
	else:
		player.position = target_position
		current_animation = AnimationState.STOPPED
		# Set stopped animation here if applicable

# Function to update animations based on direction
func update_animation(direction: Vector2) -> void:
	if direction.length() == 0:
		current_animation = AnimationState.STOPPED
		animator.pause()
		animator.set_frame_and_progress(0, 0)
		return

	var new_animation: AnimationState

	# Determine the primary direction based on x and y components
	if abs(direction.x) > abs(direction.y):  # More horizontal movement
		if direction.x > 0:
			new_animation = AnimationState.SOUTH_EAST  # Moving east
		else:
			new_animation = AnimationState.NORTH_WEST  # Moving west
	else:  # More vertical movement
		if direction.y > 0:
			new_animation = AnimationState.SOUTH_EAST  # Moving south
		else:
			new_animation = AnimationState.NORTH_EAST  # Moving north

	# Check for diagonal movements
	if direction.x < 0 and direction.y < 0:
		new_animation = AnimationState.NORTH_WEST  # Moving northwest
	elif direction.x > 0 and direction.y < 0:
		new_animation = AnimationState.NORTH_EAST  # Moving northeast
	elif direction.x < 0 and direction.y > 0:
		new_animation = AnimationState.SOUTH_WEST  # Moving southwest
	elif direction.x > 0 and direction.y > 0:
		new_animation = AnimationState.SOUTH_EAST  # Moving southeast

	# Update animation only if the state has changed
	if current_animation != new_animation:
		current_animation = new_animation

		match current_animation:
			AnimationState.NORTH_EAST:
				animator.play("NE_Walk")
			AnimationState.NORTH_WEST:
				animator.play("NW_Walk")
			AnimationState.SOUTH_WEST:
				animator.play("SW_Walk")
			AnimationState.SOUTH_EAST:
				animator.play("SE_Walk")
