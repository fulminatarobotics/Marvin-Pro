extends Node

var animationPlayerFade

var fileDir

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().set_auto_accept_quit(false)
	
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		print("Quitting!")
		if len(global.botOrder) > 0:
			saveFile("user://lastPath")
		elif FileAccess.file_exists("user://lastPath.yaml"):
			print("file Here")
			DirAccess.remove_absolute("user://lastPath.yaml")
		get_tree().quit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var botList = []
	botList.append_array(global.botOrder)
	var clipBoardString
	var RRFileCon
	if Input.is_action_just_pressed("ui_c") and len(botList) > 0 and !global.hoveringGUI:
		clipBoardString = ""
		print("copy")
		clipBoardString = "<REPLACE_WITH_SampleMecDrive>.setPoseEstimate(new Pose2d(" + str(snapped(-botList[0].position.z*12,0.001)) + "," + str(snapped(-botList[0].position.x*12,0.001)) + ", Math.toRadians(" + str(snapped(rad_to_deg(botList[0].rotation.y),0.01)) + ")));"
		clipBoardString += "\n"
		clipBoardString += "Trajectory <REPLACE_WITH_TRAJ_NAME> = <REPLACE_WITH_SampleMecDrive>.trajectoryBuilder(<REPLACE_WITH_SampleMecDrive>.getPoseEstimate(), Math.toRadians(" + str(snapped(rad_to_deg(botList[0].find_child("TangentMover").rotation.y),0.01)) + "))"
		clipBoardString += "\n"
		
		botList.remove_at(0)
		
		for bot in botList:
			clipBoardString += ".splineToSplineHeading(new Pose2d(" + str(snapped(-bot.position.z*12,0.001)) + "," + str(snapped(-bot.position.x*12,0.001)) + ", Math.toRadians(" + str(snapped(rad_to_deg(bot.rotation.y),0.01)) + ")), Math.toRadians(" + str(snapped(rad_to_deg(bot.find_child("TangentMover").rotation.y),0.01)) + "))" 
			clipBoardString += "\n"
		clipBoardString += ".build();"
		
		animationPlayerFade.get_parent().text = "[center]Code copied to clipboard!"
		animationPlayerFade.play("fade")
		DisplayServer.clipboard_set(clipBoardString)
		
		#-------------ROAD RUNNER-----------------------------------------------
	if Input.is_action_just_pressed("save") and len(botList) > 0 and !global.hoveringGUI:
		if fileDir.text != "Save path...":
			saveFile(fileDir.text)
			
func saveFile(path):
	var botList = []
	botList.append_array(global.botOrder)
	var RRFileCon = ""
	RRFileCon += "#" + str(global.botDimentions.x) + "," + str(global.botDimentions.y) + "," + str(global.botDimentions.z)
	RRFileCon += ("---\nstartPose:\n  x: " + str(snapped(-botList[0].position.z*12,0.00001))
	+ "\n  y: " + str(snapped(-botList[0].position.x*12,0.00001))
	+ "\n  heading: " + str(snapped(botList[0].rotation.y,0.0001))
	+ "\nstartTangent: " + str(snapped(botList[0].find_child("TangentMover").rotation.y,0.01))
	+ "\nwaypoints:")
	
	botList.remove_at(0)
	
	for bot in botList:
		RRFileCon += ("\n- position:"+
			"\n    x: " + str(snapped(-bot.position.z*12,0.001))+
			"\n    y: " + str(snapped(-bot.position.x*12,0.001))+
			"\n  heading: " + str(snapped(bot.rotation.y,0.01))+
			"\n  tangent: " + str(snapped(bot.find_child("TangentMover").rotation.y,0.01))+
			"\n  interpolationType: \"SPLINE\"")
	RRFileCon += "\nresolution: 0.25"+"\nversion: 1"
	var RoadRunnerFile = FileAccess.open(path+".yaml", FileAccess.WRITE)
	RoadRunnerFile.store_line(RRFileCon)
	
	animationPlayerFade.get_parent().text = "[center]Path saved to " + path +".yaml"
	animationPlayerFade.play("fade")
