extends RichTextLabel

@export var gradient: Gradient
var time = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	print(gradient)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#set("theme_override_colors/default_color",Color.RED)
	time += delta *0.5
	var color = gradient.sample(time - int(time))
	var without_alpha = color.to_html(false) # Returns "ffffff"
	if self.name == "first":
		self.text = "Program created by [color=#" + without_alpha+"]TNTeon[/color]
	https://github.com/TNTeon
	
Field created by [color=#" + without_alpha+"]Clara[/color]
	https://github.com/c-kelly-3158

Hats idea by [color=#" + without_alpha+"]Milquetoast[/color] (ty you're amazing)

Top hat design by [color=#" + without_alpha+"]MattBeker[/color]
	https://www.blendswap.com/blend/16889

Cowboy hat design by [color=#" + without_alpha+"]3d errorist[/color]
	https://www.youtube.com/watch?v=GAOTxK5BDnk"
	elif self.name == "second":
		self.text = "[color=#" + without_alpha+"]Bogey and Chipper[/color] for being the best of boys while I worked on this"
	elif self.name == "third":
		self.text = "[color=#" + without_alpha+"]Pearl and Marina[/color] for the music I played non-stop while working on this"
	elif self.name == "forth":
		self.text = "[color=#" + without_alpha+"]Boen[/color] for breaking the program within the first 5 minutes of receiving it"
