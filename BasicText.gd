extends Label3D

var savedText

# Called when the node enters the scene tree for the first time.
func _ready():
	savedText = self.text


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if global.KC:
		self.text = ("Well hi there! Congrats on finding this (unless you used source code lol)!
					\nWhen you input the konami code a few things happen!
					\n	1. You get some snazzy looking robots
					\n	2. You get a new tab in the instructions list
					\n	3. And of course, you do a backfip!
					\nHope you enjoy the program!")
	else:
		self.text = savedText
