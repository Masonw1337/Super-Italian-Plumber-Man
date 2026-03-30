extends Area2D

enum State { UNBUMPED, BUMPED}
var state: int = State.UNBUMPED
var original_position: Vector2

func _ready():
	original_position = position



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body):
	if body.is_in_group("Player") and state == State.UNBUMPED:
		bump_block()

func  bump_block():
	state = State.BUMPED
	$Sprite2D.frame=1
	match Global.current_state:
		Global.PlayerState.SMALL:
			Global.spawn_beer_bottle(self.global_position +Vector2(0, -20))
		Global.PlayerState.BIG, Global.PlayerState.FIRE:
			Global.spawn_fire_flower(self.global_position + Vector2(0, -30))
	
	bump_upwards()
	var timer = get_tree().create_timer(0.2)
	await timer.timeout
	bump_return()
	
func bump_upwards():
	position.y -+ 10

func bump_return():
	position = original_position
