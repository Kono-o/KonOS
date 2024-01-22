extends TextureButton

var command = ""
var keywordArray;
@onready var TerminalLine = get_node("/root/App/UI/TerminalLine")
@onready var UsernameLabel = get_node("/root/App/UI/UsernameLabel")

func keywordEngine():
	if keywordArray.size() > 2:
		if keywordArray[0] == "name":
			if keywordArray [1] == "set":
				UsernameLabel.text = keywordArray[2]


func _on_button_up():
	command = TerminalLine.text
	TerminalLine.text = ""
	keywordArray = command.split(' ',false, 64)
	#for i in keywordArray.size():
	#	print(keywordArray[i])
	keywordEngine()

func _ready():
	pass

func _process(delta):
	pass
