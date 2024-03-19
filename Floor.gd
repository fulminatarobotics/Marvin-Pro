extends MeshInstance3D

@onready var whiteField = load("res://whiteFieldBackground.png")
@onready var darkField = load("res://custom-centerstage-field-diagrams-works-with-meepmeep-v0-osvn5chufpob1.png")
var fieldControlButton
var worldEnv
# Called when the node enters the scene tree for the first time.
func _ready():
	self.material_override.albedo_texture = darkField
	fieldControlButton = get_parent().find_child("settings").find_child("CanvasLayer").find_child("CheckButton3")
	worldEnv = get_parent().find_child("WorldEnvironment")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if fieldControlButton.button_pressed:
		worldEnv.environment.background_color = Color(0.8,0.8,0.8)
		self.material_override.albedo_texture = whiteField
	else:
		worldEnv.environment.background_color = Color(0.2,0.2,0.2)
		self.material_override.albedo_texture = darkField
