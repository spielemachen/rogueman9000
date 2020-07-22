extends Camera2D

func _ready():
	pass # Replace with function body.


func _process(delta):
	var movement = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		movement += Vector2.LEFT
	if Input.is_action_pressed("ui_right"):
		movement += Vector2.RIGHT
	if Input.is_action_pressed("ui_up"):
		movement += Vector2.UP
	if Input.is_action_pressed("ui_down"):
		movement += Vector2.DOWN
	position += movement * delta * 100
