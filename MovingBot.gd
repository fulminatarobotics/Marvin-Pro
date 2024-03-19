extends MeshInstance3D

@onready var ghostBlock = $"../../../ghostBox"
@onready var curve = $"../.."
@onready var fullCurve = $"../../../Path3D"

var progress
var pathSection

var showingPreview = false

var speed = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	progress = 0
	visible = false
	pathSection = 0
	curve = curve.curve
	fullCurve = fullCurve.curve
	
	global.previewBot = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	speed = global.speedSlider
	global.isPreviewing = showingPreview
	
	if Input.is_action_just_pressed("ui_q") and len(global.botOrder) >= 2:
		if showingPreview:
			self.visible = false
			showingPreview = false
			global.hoveringGUI = false
			pathSection = 0
		else:
			self.scale = ghostBlock.scale
			self.visible = true
			progress = 0
			showingPreview = true
			
	if showingPreview:
		if len(global.botOrder) < 2:
			showingPreview = false
			self.visible = false
		else:
			global.hoveringGUI = true
			
		
		progress += speed * delta
		self.position.y = ghostBlock.scale.y/2
		
		if len(global.botOrder) > 1:
			curve.clear_points()
			if progress >=0.999:
				if pathSection != len(global.botOrder)-2:
					pathSection += 1
				else:
					pathSection = 0
				progress = 0
			curve.add_point(fullCurve.get_point_position(pathSection),fullCurve.get_point_in(pathSection), fullCurve.get_point_out(pathSection))
			curve.add_point(fullCurve.get_point_position(pathSection+1),fullCurve.get_point_in(pathSection+1), fullCurve.get_point_out(pathSection+1))
			
			var currentBotRotation = global.botOrder[pathSection].rotation.y
			var secondBotRotation = global.botOrder[pathSection+1].rotation.y
			var secondBotRotPlus = global.botOrder[pathSection+1].rotation.y + 2 * PI
			var secondBotRotMinus = global.botOrder[pathSection+1].rotation.y - 2 * PI
			var minSecondsBotRot = min(abs(currentBotRotation-secondBotRotation),abs(currentBotRotation-secondBotRotMinus),abs(currentBotRotation-secondBotRotPlus))
			
			if minSecondsBotRot == abs(currentBotRotation-secondBotRotation):
				self.rotation.y = lerp(currentBotRotation,secondBotRotation, progress)
			elif minSecondsBotRot == abs(currentBotRotation-secondBotRotMinus):
				self.rotation.y = lerp(currentBotRotation,secondBotRotMinus, progress)
			else:
				self.rotation.y = lerp(currentBotRotation,secondBotRotPlus, progress)
			get_parent().progress_ratio = progress
func stopPreview():
	self.visible = false
	showingPreview = false
	global.hoveringGUI = false
	pathSection = 0
