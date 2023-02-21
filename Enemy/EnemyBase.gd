extends Node2D

export var move_direction = Vector2(0,0)
export var move_speed = 3.0
export var is_white = true
export(Texture) var sprite_white
export(Texture) var sprite_black

onready var enemy_sprite: Sprite = $EnemySprite

func _ready() -> void:
	#Normalize move direction to total 1 (wouldn't want this to affect our speed)
	move_direction = move_direction.normalized()
	#Set properties according to the export vars
	var outline_color = Color.black
	var correct_sprite:Texture = sprite_white
	if not is_white:
		outline_color = Color.white
		correct_sprite = sprite_black
		pass
	enemy_sprite.texture = correct_sprite
	enemy_sprite.material.set_shader_param("inputOutlineColor",outline_color)
	enemy_sprite.material.set_shader_param("inputTextureSize",correct_sprite.get_size())
	pass

func _physics_process(delta: float) -> void:
	#Move in the moveDirection by the speed * delta
	position.x += move_direction.x*move_speed*delta
	position.y += move_direction.y*move_speed*delta
	pass

func _on_EnemyHitbox_body_entered(body: Node) -> void:
#	if body is Player:
#		print("Collided with player")
#		pass
	pass
