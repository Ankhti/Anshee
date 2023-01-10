extends KinematicBody2D
class_name Mineas

const GRAVITY = 800
var velocity = Vector2()
var speed = 200
onready var obj = get_parent().get_node("Anshee")
onready var animation: AnimatedSprite = $AnimatedSprite
onready var lifebar: ProgressBar = $LifeBar

var health = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func take_damage():
	health -= 1
	lifebar.set_value(health * lifebar.step)
	print(health * lifebar.step)
	if health == 0:
		hide()

func _physics_process(delta):
	var dir = (obj.global_position - global_position).normalized()
	if dir.x < 0:
		animation.flip_h = true
		velocity.x += delta * speed * -1
	else:
		animation.flip_h = false
		velocity.x += delta * speed
	
	velocity.y += delta * GRAVITY
	velocity = move_and_slide(velocity, Vector2.UP)
	
	animation.play("run_bw")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
