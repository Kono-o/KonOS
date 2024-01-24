extends LineEdit

@onready var terminal_line = get_node("/root/App/UI/terminal-line")

signal update_user(newName:String)

func keywordEngine(command):
	var keywordArray = command.split(' ',false, 64)
	
	if keywordArray.size() > 2:
		if keywordArray[0].to_lower() == "name":
			if keywordArray [1].to_lower() == "set":
				update_user.emit(keywordArray[2])

func _process(delta):
	if Input.is_action_just_released("enter"):
		keywordEngine(terminal_line.text)
		terminal_line.text = ""
