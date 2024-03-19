extends Node

var actions = []

var redoActions = []

var loadFile
var loadFileString = ""
var comingFromRedo = false

const botScene = preload("res://bot.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("undo") and len(actions) > 0:
		var lastAction = actions[len(actions)-1]
		if lastAction[0] == "Created":
			var lastBot = global.botOrder[len(global.botOrder)-1]
			redoActions.append(["Deleted",lastBot.position.x,lastBot.position.z,lastBot.rotation.y,lastBot.find_child("TangentMover").rotation.y,global.botOrder.find(lastBot),lastBot.returnOrder()])
			delete()
			actions.remove_at(len(actions)-1)
		if lastAction[0] == "Deleted":
			redoActions.append(["Created",lastAction[5]])
			placeBot(lastAction[1],lastAction[2],lastAction[3],lastAction[4],lastAction[5],lastAction[6])
			actions.remove_at(len(actions)-1)
		if lastAction[0] == "movedOrder":
			redoActions.append(["movedOrder",lastAction[1],lastAction[2]])
			moveOrder(lastAction[1],lastAction[2])
			actions.remove_at(len(actions)-1)
		if lastAction[0] == "posChanged":
			var currentBot = global.botOrder[lastAction[5]]
			redoActions.append(["posChanged",currentBot.position.x,currentBot.position.z,currentBot.rotation.y,currentBot.find_child("TangentMover").rotation.y,lastAction[5]])
			posMoved(lastAction[1],lastAction[2],lastAction[3],lastAction[4],lastAction[5])
			actions.remove_at(len(actions)-1)
		if lastAction[0] == "loadedFile":
			#[["loadedFile"],[x,y,h,t,o,s],[x,y,h,t,o,s]]
			if lastAction[1] != "":
				redoActions.append(["reLoad",lastAction[1]])
			else:
				redoActions.append(["deleteAll"])
			global.botOrder.clear()
			global.invisBots = false
			lastAction.remove_at(0)
			lastAction.remove_at(0)
			for action in lastAction:
				placeBot(action[0],action[1],action[2],action[3],action[4],action[5])
			actions.remove_at(len(actions)-1)
	if Input.is_action_just_pressed("redo") and len(redoActions) > 0:
		var lastRedo = redoActions[len(redoActions)-1]
		#print(lastRedo[0])
		if lastRedo[0] == "reLoad":
			comingFromRedo = true
			loadFile._on_file_dialog_file_selected(lastRedo[1])
			redoActions.remove_at(len(redoActions)-1)
		if lastRedo[0] == "Deleted":
			actions.append(["Created"])
			placeBot(lastRedo[1],lastRedo[2],lastRedo[3],lastRedo[4],lastRedo[5],lastRedo[6])
			redoActions.remove_at(len(redoActions)-1)
		if lastRedo[0] == "Created":
			var lastBot = global.botOrder[lastRedo[1]]
			actions.append(["Deleted",lastBot.position.x,lastBot.position.z,lastBot.rotation.y,lastBot.find_child("TangentMover").rotation.y,global.botOrder.find(lastBot),lastBot.returnOrder()])
			global.botOrder.remove_at(lastRedo[1])
			redoActions.remove_at(len(redoActions)-1)
		if lastRedo[0] == "posChanged":
			var currentBot = global.botOrder[lastRedo[5]]
			actions.append(["posChanged",currentBot.position.x,currentBot.position.z,currentBot.rotation.y,currentBot.find_child("TangentMover").rotation.y,lastRedo[5]])
			posMoved(lastRedo[1],lastRedo[2],lastRedo[3],lastRedo[4],lastRedo[5])
			redoActions.remove_at(len(redoActions)-1)
		if lastRedo[0] == "movedOrder":
			actions.append(["movedOrder",lastRedo[1],lastRedo[2]])
			moveOrder(lastRedo[1],lastRedo[2])
			redoActions.remove_at(len(redoActions)-1)
		if lastRedo[0] == "deleteAll":
			actions.append(["loadedFile"])
			var appendToThis = actions[len(actions)-1]
			appendToThis.append("")
			for bot in global.botOrder:
				appendToThis.append([bot.position.x,bot.position.z,bot.rotation.y,bot.find_child("TangentMover").rotation.y,global.botOrder.find(bot),bot.returnOrder()])
			global.botOrder.clear()
			redoActions.remove_at(len(redoActions)-1)

func delete():
	global.botOrder.remove_at(len(global.botOrder)-1)

func placeBot(x,z,heading,tangent,order,selfOrder):
	var instanceBot = botScene.instantiate()
	get_tree().get_root().add_child(instanceBot)
	instanceBot.stopFirstClick()
	instanceBot.setOrderCreated(selfOrder)
	instanceBot.position = Vector3(x,global.botDimentions.y/2.0,z)
	instanceBot.rotation.y = heading
	instanceBot.find_child("TangentMover").rotation.y = tangent
	global.botOrder.insert(order, instanceBot)

func moveOrder(wasPos, nowPos):
	global.botOrder.insert(nowPos, global.botOrder.pop_at(wasPos))

func posMoved(x,z,heading,tangent,order):
	print(x, " ", z, " ", heading, " ", tangent, " ", order)
	var currentbot = global.botOrder[order]
	currentbot.position = Vector3(x,global.botDimentions.y/2.0,z)
	currentbot.rotation.y = heading
	currentbot.find_child("TangentMover").rotation.y = tangent

func resetRedo():
	redoActions.clear()
