extends Node3D

var justCalledKC = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if global.KC and !justCalledKC:
		var ran = randi_range(1, 3)
		if (ran == 1):
			$temp.visible = true
		elif (ran == 2):
			$temp2.visible = true
		elif (ran == 3):
			$temp3.visible = true
		justCalledKC = true
	elif !global.KC:
		justCalledKC = false
		$temp3.visible = false
		$temp2.visible = false
		$temp.visible = false
