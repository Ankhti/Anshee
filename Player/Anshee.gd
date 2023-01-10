extends KinematicBody2D
class_name Player

const Mineas = preload("../Boss/Mineas.gd")

# warning-ignore:unused_signal
signal hopped_off_entity

#onready var state_machine: StateMachine = $StateMachine
onready var animation: AnimatedSprite = $AnimatedSprite
onready var attackShape: CollisionShape2D = $CollisionAttack
onready var hook: Position2D = $Hook

onready var skin: Position2D = $Skin
onready var collider: CollisionShape2D = $CollisionShape2D setget ,get_collider

#onready var stats: Stats = $Stats
#onready var hitbox: Area2D = $HitBox
onready var camera_rig: Position2D = $CameraRig
onready var shaking_camera: Camera2D = $CameraRig/ShakingCamera

onready var ledge_wall_detector: Position2D = $LedgeWallDetector
onready var floor_detector: RayCast2D = $FloorDetector

onready var pass_through: Area2D = $PassThrough


const FLOOR_NORMAL := Vector2.UP
const GRAVITY = 600
const WALK_SPEED = 300
const RUN_SPEED = 600
const JUMP_FORCE = 500

var screen_size
var velocity = Vector2()
var is_active := true setget set_is_active
var has_teleported := false
var last_checkpoint: Area2D = null
var parent = get_parent()
var bAttack = false

func _ready() -> void:
	animation.animation = "idle-bw"
	animation.connect("animation_finished", self, "idle")
	animation.playing = true
	screen_size = get_viewport_rect().size
	
# TODO: Add damage
#func take_damage(source: Hit) -> void:
#	stats.take_damage(source)


func set_is_active(value: bool) -> void:
	is_active = value
	if not collider:
		return
	collider.disabled = not value
	hook.is_active = value
	ledge_wall_detector.is_active = value
	#TODO hitbox.monitoring = value

func get_collider() -> CollisionShape2D:
	return collider

func _unhandled_input(event: InputEvent) -> void:
	pass
	#print(event)


func _physics_process(delta):
	velocity.y += delta * GRAVITY
	var speed = WALK_SPEED
	var currentAnimation = "walk-bw"
	
	if bAttack == false:
		if Input.is_action_pressed("run"):
			speed = RUN_SPEED
			currentAnimation = "run-bw"
			
		if Input.is_action_pressed("move_left"):
			velocity.x = -speed
			animation.flip_h = true
			animation.animation = currentAnimation
		
		elif Input.is_action_pressed("move_right"):
			velocity.x = speed
			animation.flip_h = false
			animation.animation = currentAnimation
		else:
			# velocity.x = 0
			# smoothen the stop
			velocity.x = lerp(velocity.x, 0, 0.1)
		
		if Input.is_action_pressed("jump") and is_on_floor():
			velocity.y = -JUMP_FORCE

	velocity = move_and_slide(velocity, Vector2.UP)

	# Launch attack
	if Input.is_action_pressed("attack"):
		animation.animation = "attack-bw"
		bAttack = true
	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name == "Mineas" and bAttack:
			var mineas = collision.collider
			mineas.take_damage()
			bAttack = false
			break
	

	# prevent player going out of screen
	#position.x = clamp(position.x, 0, screen_size.x)
	#position.y = clamp(position.y, 0, screen_size.y)
	
	var center = get_viewport_rect().size / 2
	
#	if (position.x > center.x):
#		var pos = camera.move_local_x(2)
#		print(pos)

func idle() -> void:
	if bAttack:
		bAttack = false
	animation.animation = 'idle-bw'

func _on_Player_health_depleted() -> void:
	pass
	#state_machine.transition_to("Die", {last_checkpoint = last_checkpoint})

func attack_can_hit():
	print("Toto")
