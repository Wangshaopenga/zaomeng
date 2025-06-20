class_name BaseEmemy
extends CharacterBody2D

@onready var stats: EnemyStats = $EnemyStats


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()


func _on_hurtbox_hurt(hitbox: Hitbox) -> void:
	var damage = hitbox.owner.take_damage()
	stats.hp -= damage
	print_debug("%s hit %s %dhp" % [self.name, hitbox.owner.name, damage])
	if stats.hp == 0:
		queue_free()
