extends CharacterBody2D

var speed = 300
enum faces {down,left,right,up, rightup, rightdown, leftup, leftdown}
var facing = faces.down

func _physics_process(delta: float) -> void:
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if input.x > 0:
		if input.y > 0:
			$AnimatedSprite2D.play("walk_downside")
			facing = faces.rightdown
		elif input.y < 0:
			$AnimatedSprite2D.play("walk_upside")
			facing = faces.rightup
		else:
			$AnimatedSprite2D.play("walk_side")
			facing = faces.right
		$AnimatedSprite2D.flip_h = false
	elif input.x < 0:
		if input.y > 0:
			$AnimatedSprite2D.play("walk_downside")
			facing = faces.leftdown
		elif input.y < 0:
			$AnimatedSprite2D.play("walk_upside")
			facing = faces.leftup
		else:
			$AnimatedSprite2D.play("walk_side")
			facing = faces.left
		$AnimatedSprite2D.flip_h = true
	elif input.x == 0:
		if input.y > 0:
			$AnimatedSprite2D.play("walk_down")
			facing = faces.down
		elif input.y < 0:
			$AnimatedSprite2D.play("walk_up")
			facing = faces.up
		$AnimatedSprite2D.flip_h = false
	
	if input == Vector2.ZERO:
		if facing == faces.up:
			$AnimatedSprite2D.play("idle_up")
			$AnimatedSprite2D.flip_h = false
		elif facing == faces.down:
			$AnimatedSprite2D.play("idle_down")
			$AnimatedSprite2D.flip_h = false
		elif facing == faces.left:
			$AnimatedSprite2D.play("idle_side")
			$AnimatedSprite2D.flip_h = true
		elif facing == faces.right:
			$AnimatedSprite2D.play("idle_side")
			$AnimatedSprite2D.flip_h = false
		elif facing == faces.rightup:
			$AnimatedSprite2D.play("idle_upside")
			$AnimatedSprite2D.flip_h = false
		elif facing == faces.leftup:
			$AnimatedSprite2D.play("idle_upside")
			$AnimatedSprite2D.flip_h = true
		elif facing == faces.rightdown:
			$AnimatedSprite2D.play("idle_downside")
			$AnimatedSprite2D.flip_h = false
		elif facing == faces.leftdown:
			$AnimatedSprite2D.play("idle_downside")
			$AnimatedSprite2D.flip_h = true
		
	
	
	velocity = input.normalized() * speed
	
	
	
	move_and_slide()
