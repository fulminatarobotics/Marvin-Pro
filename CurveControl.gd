extends Path3D

var bezierCurve

# Called when the node enters the scene tree for the first time.
func _ready():
	bezierCurve = self.curve


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	bezierCurve.clear_points()
	for bot in global.botOrder:
		var tempPos = bot.global_position
		tempPos.y = tempPos.y-(bot.scale.y/2)
		var tempIn = bot.find_child("TangentMover").find_child("ForwardTan").global_position
		tempIn.y = tempIn.y-(bot.scale.y/2)
		tempIn = tempIn-tempPos
		var tempOut = bot.find_child("TangentMover").find_child("BackTan").global_position
		tempOut.y = tempOut.y-(bot.scale.y/2)
		tempOut = tempOut-tempPos
		bezierCurve.add_point(tempPos,tempIn,tempOut)
		
