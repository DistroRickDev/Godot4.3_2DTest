extends CharacterBody2D

const SPEED = 300.0

@onready var animation_sprite  = $AnimatedSprite2D

enum State { IDLE, WALKING, LIGHT_ATTACK, HEAVY_ATTACK }
enum Condition { STOP, MOVE, ATTACK_LIGHT, ATTACK_HEAVY }

var g_current_state : State = State.IDLE
var g_invert_h_direction : bool = false

func _animation_state_machine(condition : Condition) -> State :
	match condition:
		Condition.MOVE:
			return State.WALKING
		Condition.ATTACK_LIGHT:
			return State.LIGHT_ATTACK
		Condition.STOP:
			return State.IDLE
	return g_current_state
	
func _flip_sprite_h(direction: float):
	if direction == 0:
		return g_invert_h_direction
	g_invert_h_direction = true if direction < 0 else false
	return g_invert_h_direction
	
func _play_animation(flip_horizontal : bool = false):
	animation_sprite.flip_h = g_invert_h_direction and flip_horizontal
	match g_current_state:
		State.IDLE:
			animation_sprite.play("Idle")
		State.WALKING:
			animation_sprite.play("Walk") 
		State.LIGHT_ATTACK:
			animation_sprite.play("SideAttackLight")


func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Left", "Right")
	var v_direction := Input.get_axis("Up", "Down")
	
	if direction or v_direction:
		g_current_state = _animation_state_machine(Condition.MOVE)

	if Input.is_action_pressed("LightAttack"):
		g_current_state = _animation_state_machine(Condition.ATTACK_LIGHT)
	
	velocity.x = direction * SPEED if direction else move_toward(velocity.x, 0, SPEED)
	velocity.y = v_direction * SPEED if v_direction else move_toward(velocity.y, 0, SPEED)
	
	_play_animation(_flip_sprite_h(direction))
	move_and_slide()


func _on_animated_sprite_2d_animation_finished() -> void:
	g_current_state = _animation_state_machine(Condition.STOP)
