extends VBoxContainer

@onready var input_button_scene = preload("res://input_button.tscn")
@onready var action_list = $ActionsList
# Called when the node enters the scene tree for the first time.

var is_remapping = false
var action_to_remap = null
var remapping_button = null

var input_actions = {
	"ui_o": "Enter Orthographic View",
	"ui_p": "Enter Perspective View",
	"ui_control": "Enter 3D Camera Movement",
	"ui_up": "Move Forward",
	"ui_down": "Move Down",
	"ui_left": "Move Left",
	"ui_right": "Move Right",
	"ui_space": "Move Up",
	"ui_shift": "Move Down/Snap To Grid",
	"ui_q": "View Preview",
	"ui_i": "Toggle Bots Visiblity",
	"ui_r": "Remove All Bots",
	"ui_c": "Copy Path to Clipboard",
	"save": "Save Shortcut"
}

var boundActions = []

func _ready():
	_load_saved_actions()
	_create_action_list()
	
func _load_saved_actions():
	if FileAccess.file_exists("user://savegame.save"):
		var save_game = FileAccess.open("user://savegame.save", FileAccess.READ)
		var json_string = save_game.get_line()
		var json = JSON.new()
		var error = json.parse(json_string)
		if error == OK:
			var data_received = json.data
			if typeof(data_received) == 27:
				print("loading")
				for item in data_received:
					if data_received[item][0].contains("InputEventKey"):
						var ev = InputEventKey.new()
						ev.keycode = int(data_received[item][0])
						InputMap.action_erase_events(item)
						InputMap.action_add_event(item, ev)
					else:
						var ev = InputEventMouseButton.new()
						ev.button_index = 3
						InputMap.action_erase_events(item)
						InputMap.action_add_event(item, ev)
			else:
				print("Unexpected data")
		else:
			print("Not Here")
	else:
		global.firstOpen = true
		print("missing and saving")
		save()

func _create_action_list():
	#InputMap.load_from_project_settings()
	for item in action_list.get_children():
		item.queue_free()
	
	for action in input_actions:
		var button = input_button_scene.instantiate()
		var action_label = button.find_child("LabelAction")
		var input_label = button.find_child("LabelInputs")
		
		boundActions.append(InputMap.action_get_events(action)[0].as_text().trim_suffix(" (Physical)"))
		
		action_label.text = input_actions[action]
		
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" (Physical)")
		else:
			input_label.text = ""
			
		action_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button,action))
		
func _on_input_button_pressed(button, action):
	if !is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("LabelInputs").text = "Press key to bind..."

func _input(event):
	
	if is_remapping:
		if event is InputEventKey or (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_MIDDLE):
			if event.as_text().trim_suffix(" (Physical)") != "Escape":
				if event.as_text() not in boundActions or InputMap.action_get_events(action_to_remap)[0].as_text().trim_suffix(" (Physical)") == event.as_text():
					boundActions.remove_at(boundActions.find(InputMap.action_get_events(action_to_remap)[0].as_text().trim_suffix(" (Physical)")))
					InputMap.action_erase_events(action_to_remap)
					InputMap.action_add_event(action_to_remap, event)
					print(action_to_remap)
					print(event)
					_update_action_list(remapping_button, event)
					
					boundActions.append(event.as_text().trim_suffix(" (Physical)"))
					
					is_remapping = false
					action_to_remap = null
					remapping_button = null
					
					save()
				else:
					remapping_button.find_child("LabelInputs").text = "Already Mapped..."
			else:
				_update_action_list(remapping_button, InputMap.action_get_events(action_to_remap)[0])
				is_remapping = false
				action_to_remap = null
				remapping_button = null
			accept_event()
			
func _update_action_list(button, event):
	button.find_child("LabelInputs").text = event.as_text().trim_suffix(" (Physical)")
	
func save():
	var save_game = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var save_dict = {
		"ui_o": InputMap.action_get_events("ui_o"),
		"ui_p": InputMap.action_get_events("ui_p"),
		"ui_control": InputMap.action_get_events("ui_control"),
		"ui_up": InputMap.action_get_events("ui_up"),
		"ui_down": InputMap.action_get_events("ui_down"),
		"ui_left": InputMap.action_get_events("ui_left"),
		"ui_right": InputMap.action_get_events("ui_right"),
		"ui_space": InputMap.action_get_events("ui_space"),
		"ui_shift": InputMap.action_get_events("ui_shift"),
		"ui_q": InputMap.action_get_events("ui_q"),
		"ui_i": InputMap.action_get_events("ui_i"),
		"ui_r": InputMap.action_get_events("ui_r"),
		"ui_c": InputMap.action_get_events("ui_c")
	}
	var json_string = JSON.stringify(save_dict)
	save_game.store_line(json_string)
