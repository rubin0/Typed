extends Camera2D

export var decay = 0.8
export var max_offset = Vector2(100, 75)
export var max_roll = 0.1

func _ready():
	randomize()

func add_trauma(amount):
	trauma = min(trauma + amount, 1)
	
func _process(delta):
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()
		
func shake():
	var amount = pow(trauma, trauma_power)
	rotation = max_roll * amount * rand_range(-1, 1)
	offset.x = max_offset.x * amount * rand_range(-1, 1)
	offset.y = max_offset.y * amount * rand_range(-1, 1)

func trigger(camera_pos : Vector2):

	$Tween.interpolate_property(self, "global_position",
			global_position, camera_pos, 2.5,
			Tween.TRANS_QUAD, Tween.EASE_IN, .2)
					
	$Tween.start()


var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].
