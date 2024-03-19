extends CharacterBody3D


const SPEED = 5.0


@onready var lineEdit = $"../settings/LineEdit"
@onready var neck := $Neck
@onready var camera := $Neck/Camera3D

var sequence = [
	"Up",
	"Up",
	"Down",
	"Down",
	"Left",
	"Right",
	"Left",
	"Right",
	"B",
	"A"
]
var sequence_index = 0

var flip = false
var flipRot = 0

func _ready():
	global.textInput = lineEdit

#Get mouse movement for camera only if control is held
func _unhandled_input(event):
	if Input.is_action_pressed("ui_control") and global.camPerspective == true and global.DontMoveCam == false:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED and global.camPerspective == true:
		if event is InputEventMouseMotion and !flip:
			neck.rotate_y(-event.relative.x*0.001)
			camera.rotate_x(-event.relative.y*0.001)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-85), deg_to_rad(85))
	if event is InputEventKey and event.pressed:
		if event.as_text_key_label() == sequence[sequence_index]:
			sequence_index += 1
			if sequence_index == sequence.size():
				global.KC = !global.KC
				flip = true
				flipRot = 0
				sequence_index = 0
		else:
			sequence_index = 0

# Move character, Space/Shift for up and down, wasd
func _physics_process(delta):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED and global.camPerspective == true and $"../settings/LineEdit".visible == false:
		var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var direction = (neck.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
		if Input.is_action_pressed("ui_space") and !Input.is_action_pressed("ui_shift"):
			velocity.y = 1 * SPEED
		elif Input.is_action_pressed("ui_shift") and !Input.is_action_pressed("ui_space"):
			velocity.y = -1 * SPEED
		else:
			velocity.y = 0
		move_and_slide()
		
	if flip:
		flipRot += delta * 5
		camera.rotate_x(delta * 5)
		if flipRot >= 2*PI:
			flip = false
