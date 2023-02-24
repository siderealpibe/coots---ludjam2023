class_name Laser
extends EnemyHitBox

export var SPEED : int = 30

onready var direction : Vector2
onready var travelling = false
onready var animations : AnimationPlayer = $AnimationPlayer

func _init() -> void:
	collision_layer = 4
	collision_mask = 16

func _ready() -> void:
	connect("area_entered", self, "_on_area_entered")

func _on_area_entered(hitbox) -> void:
	if not hitbox is DeflectBox:
		travelling = false
		animations.play("Impact")
		yield(animations,"animation_finished")
		queue_free()
	else:
		var old_angle = direction.angle()
		direction = (get_global_mouse_position() - global_position).normalized()
		collision_layer = 2
		$Sprite.rotation = direction.angle()
		$CollisionShape2D.rotate(direction.angle()-old_angle)
		match randi()%3:
			0:
				$DeflectSound1.play()
			1:
				$DeflectSound2.play()
			2:
				$DeflectSound3.play()
	
func shoot(direction_vector: Vector2) -> void:
	direction = direction_vector
	travelling = true
	$Sprite.rotation = direction.angle()
	$CollisionShape2D.rotate(direction.angle())
	animations.play("Traveling")
	
func _process(delta) -> void:
	if direction == null or not travelling:
		return
	position += direction*SPEED
