
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"
var screen_size
var pad_size
var direction = Vector2(1.0, 0.3)

var score1 = 0
var score2 = 0

var left_pos
var right_pos
# Constant for pad speed (in pixels/second)
const INITIAL_BALL_SPEED = 200
# Speed of the ball (also in pixels/second)
var ball_speed = INITIAL_BALL_SPEED
# Constant for pads speed
const PAD_SPEED = 180
var particle


func _ready():
	particle = get_node("Particles2D")
	screen_size = get_viewport_rect().size
	pad_size = get_node("left").get_texture().get_size() * get_node("left").get_scale()
	set_process(true)
	if(OS.get_name()=="Android"):
		set_process_input(true);
	pass

func _process(delta):
	var ball_pos = get_node("ball").get_pos()
	var left_rect = Rect2( get_node("left").get_pos() - pad_size*0.5, pad_size )
	var right_rect = Rect2( get_node("right").get_pos() - pad_size*0.5, pad_size )
	# Integrate new ball postion
	ball_pos += direction * ball_speed * delta
	
	if((ball_pos.y < 0 and direction.y < 0) or (ball_pos.y > screen_size.y and direction.y > 0)):
		direction.y *= -1
		var hit_edge = get_node("SamplePlayer").play("hit",true);
		get_node("SamplePlayer").set_pitch_scale(hit_edge,5);
	
	# Flip, change direction and increase speed when touching pads
	if ((left_rect.has_point(ball_pos) and direction.x < 0) or (right_rect.has_point(ball_pos) and direction.x > 0)):
		direction.x = -direction.x
		direction.y = randf()*2.0 - 1
		direction = direction.normalized()
		ball_speed *= 1.1
		#Start particle emission
		particle.set_pos(ball_pos)
		particle.set_emitting (true)
		#Play sound
		get_node("SamplePlayer").play("hit",false);
	
	# Check gameover
	if (ball_pos.x < 0 or ball_pos.x > screen_size.x):
		#play audio
		get_node("SamplePlayer").play("lose",false);
		if (ball_pos.x < 0) :  
			score2+=1
			get_node("UI/Score2").set_text(str(score2))
		else : 
			score1+=1
			get_node("UI/Score1").set_text(str(score1))
		
		ball_pos = screen_size*0.5
		ball_speed = INITIAL_BALL_SPEED
		direction = Vector2(-1, 0)
	
	get_node("ball").set_pos(ball_pos)
	
	left_pos = get_node("left").get_pos()
	
	if (left_pos.y>0 and Input.is_action_pressed("left_move_up")):
		left_pos.y += -PAD_SPEED * delta
	if (left_pos.y< screen_size.y and Input.is_action_pressed("left_move_down")):
		left_pos.y += PAD_SPEED * delta
	get_node("left").set_pos(left_pos)
	
	right_pos = get_node("right").get_pos()
	if (right_pos.y>0 and Input.is_action_pressed("right_move_up")):
		right_pos.y += -PAD_SPEED * delta
	if (right_pos.y< screen_size.y and Input.is_action_pressed("right_move_down")):
		right_pos.y += PAD_SPEED * delta
	get_node("right").set_pos(right_pos)

func _input(event):
	if event.type == InputEvent.SCREEN_DRAG:
		if(event.x > 320):
			right_pos.y = event.y
			get_node("right").set_pos(right_pos)
		else:
			left_pos.y = event.y
			get_node("left").set_pos(left_pos)