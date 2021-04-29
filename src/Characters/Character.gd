extends KinematicBody2D

class_name Character

onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox

var HitPoints = 100
var knockback = 1
var resistance = 0
var weight = 1
var speed = 100
var acceleration = 20
var friction = 20
var velocity = Vector2.ZERO

enum {
	MOVE,
	ATTACK,
	DODGE
}

var state = MOVE

func _ready():
	animationTree.active = true
	swordHitbox.knockback_vector = Vector2.RIGHT

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state(delta)
		DODGE:
			dodge_state(delta)

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity += input_vector * acceleration * delta
		velocity = velocity.clamped(speed * delta)
		swordHitbox.knockback_vector = input_vector
		
		animationState.travel("Run")
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction*delta)
		animationState.travel("Idle")
	
	move_and_collide(velocity)
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func attack_state(delta):
	animationState.travel("Attack")
	move_and_collide(velocity)
	velocity = velocity.move_toward(Vector2.ZERO, friction*delta/5)
	
func attack_animation_finished():
	state = MOVE
	
func dodge_state(delta):
	pass
