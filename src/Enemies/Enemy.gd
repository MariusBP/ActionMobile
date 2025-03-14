extends KinematicBody2D

class_name Enemy

onready var stats = $Stats
onready var sprite = $AnimatedSprite
onready var playerDetectionZone =  $PlayerDetectionZone
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController

const BatDeathEffect = preload("res://src/Enemies/Bat/bat_death_effect.tscn")

var state = CHASE
var velocity = Vector2.ZERO
 
enum {
	IDLE,
	WANDER,
	CHASE
}

func _ready():
	state = assign_random_state([IDLE, WANDER])

func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, stats.resistance*delta)
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, stats.friction*delta)
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
		
		WANDER:
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
			accelerate_towards_point(wanderController.target_position, delta)
			if global_position.distance_to(wanderController.target_position) <= stats.speed * delta:
				update_wander()
		
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				accelerate_towards_point(player.global_position, delta)
			else:
				state = IDLE
	
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * (stats.acceleration*2) * delta
	velocity = move_and_slide(velocity)

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * stats.speed, stats.acceleration * delta)
	sprite.flip_h = direction.x > 0

func update_wander():
	state = assign_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1,3))

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func assign_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func on_death():
	var batDeathEffect = BatDeathEffect.instance()
	get_parent().add_child(batDeathEffect)
	batDeathEffect.set_offset(Vector2(0,-12))
	batDeathEffect.global_position = global_position

func _on_Hurtbox_area_entered(area):
	velocity = area.knockback_vector * stats.knockback
	stats.health -= area.damage
	hurtbox.create_hit_effect()

func _on_Stats_no_health():
	on_death()
	queue_free()
