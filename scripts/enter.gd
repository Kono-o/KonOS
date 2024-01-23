extends TextureButton

var command = ""
var keywordArray;

@onready var TerminalLine = get_node("/root/App/UI/TerminalLine")

signal update_name(newName:String)

func keywordEngine():
	TerminalLine.text = ""
	keywordArray = command.split(' ',false, 64)
	#for i in keywordArray.size():
	#	print(keywordArray[i])
	
	if keywordArray.size() > 2:
		if keywordArray[0] == "name":
			if keywordArray [1] == "set":
				update_name.emit(keywordArray[2])


func _on_button_up():
	command = TerminalLine.text
	keywordEngine()

func _ready():
	pass

func _process(delta):
	pass
