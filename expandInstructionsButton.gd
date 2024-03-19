extends HBoxContainer

var expanded = false

@onready var button = $VBoxContainer/Button

func _ready():
	var counter = 0
	for item in get_parent().find_child("Organizer").get_children():
		if counter != 0:
			item.visible = !item.visible
		counter +=1
	button.release_focus()
	expanded = !expanded

func _on_button_pressed():
	if expanded:
		$AnimationPlayer.play("arrowTurn")
	else:
		$AnimationPlayer.play("arrowTurnBack")
	var counter = 0
	for item in get_parent().find_child("Organizer").get_children():
		if counter != 0:
			item.visible = !item.visible
		counter +=1
	button.release_focus()
	expanded = !expanded
	
