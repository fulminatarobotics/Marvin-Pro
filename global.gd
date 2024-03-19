extends Node

var camPerspective = true
var botDimentions = Vector3(12,12,12)
var botOrder = []
var currentMousePos
var currentObj

var camera

var numBotsCreated

var hoveringGUI = false

var snappedInches = 12

var resetColors = false

var DontMoveCam = true

var isPreviewing = false

var textInput

var usingTextEdit

var KC = false

var speedSlider = 0.5

var invisBots = false

var loadingFile = false

var previewBot

var firstOpen = false

var directoryOpen = false

var openedInstructions = false

# Called when the node enters the scene tree for the first time.
func _ready():
	numBotsCreated = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if camera != null:
		var mousePos = get_viewport().get_mouse_position()
		var rayOrigin = camera.project_ray_origin(mousePos)
		var rayEnd = rayOrigin + camera.project_ray_normal(mousePos) * 2000
		var query = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd)
		
		var spacestate = camera.get_world_3d().direct_space_state
		
		var rayArrary = spacestate.intersect_ray(query)
		
		if rayArrary.has("position"):
			currentMousePos = rayArrary["position"]
			currentObj = rayArrary["collider"]
			
	if resetColors:
		numBotsCreated = len(botOrder)
	
	if Input.is_action_just_pressed("ui_i") and (!hoveringGUI or isPreviewing):
		invisBots = !invisBots
