extends Control

var showOnOpen = false

func _ready():
	$AnimationPlayer.play("RESET")
	find_child("CanvasLayer").find_child("Panel").visible = true
	

func _input(event):
	if event is InputEventKey:
		if event.keycode == 4194305 and event.pressed:
			if find_child("CanvasLayer").find_child("Panel").visible == true:
				$AnimationPlayer.play("FoldInSettings")
			else:
				$AnimationPlayer.play("FoldOutSettings")
				find_child("CanvasLayer").find_child("Panel").visible = true
		

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "FoldInSettings":
		global.hoveringGUI = false
		

func _process(delta):
	if find_child("CanvasLayer").find_child("Panel").visible:
		global.hoveringGUI = true
		global.openedInstructions = true
	else:
		global.openedInstructions = false
	if global.firstOpen and !showOnOpen:
		$AnimationPlayer.play("start")
		showOnOpen = true
	elif !showOnOpen:
		global.hoveringGUI = false
		showOnOpen = true
		
