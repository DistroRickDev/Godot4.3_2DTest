extends CharacterBody2D

# On Ready variable
@onready var animation_player = $AnimatedSprite2D
@onready var path_finder = get_parent()
@onready var cast = $RayCast2D

var life = 100

# State defining enums
enum State {IDLE, MOVING, L_ATTACKING}
enum Condition {STOP, MOVE, L_ATTACK}

# Constant values
const SPEED := 50
const animation_state_map :  Dictionary = {
	State.IDLE: "Idle", State.MOVING: "Walk", State.L_ATTACKING: "LightAttack"
}

# Global variables
var g_current_state := State.MOVING
var g_invert_h_direction:= false
var g_current_patrol_x := 0

func _animation_state_machine(condition : Condition) -> State :
	match condition:
		Condition.MOVE:
			return State.MOVING
		Condition.L_ATTACK:
			return State.L_ATTACKING
		Condition.STOP:
			return State.IDLE
	return g_current_state


func _play_animation():
	animation_player.flip_h = g_invert_h_direction
	cast.rotation_degrees = 90 if animation_player.flip_h else -90
	animation_player.play(animation_state_map[g_current_state])


func _patrol(delta):
	assert(path_finder is  PathFollow2D)
	var past_pos_x = path_finder.position.x
	path_finder.progress += SPEED  * delta
	var new_pos_x = path_finder.position.x
	g_invert_h_direction = true if past_pos_x  > new_pos_x else false
	
	
func _physics_process(delta: float) -> void:
	if g_current_state == State.MOVING:
		_patrol(delta)
	_play_animation()
	move_and_slide()
