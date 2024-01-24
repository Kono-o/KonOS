extends LineEdit

@onready var terminal_line = get_node("/root/App/UI/terminal-line")

signal update_user(newName:String)
signal update_macro(type:String,amount:int)

func keywordEngine(command):
	var keywordArray = command.split(' ',false, 16)
	
	for i in 16:
		keywordArray[i] = keywordArray[i].to_lower()
	
	if keywordArray.size() > 2:
		if keywordArray[0] == "user" or keywordArray[0] == "name":
			if keywordArray[1] == "set":
				update_user.emit(keywordArray[2])
		if keywordArray[0] == "carb" and keywordArray[1] == "add":
			update_macro.emit("c",keywordArray[2].to) 

func _process(_delta):
	if Input.is_action_just_released("enter"):
		keywordEngine(terminal_line.text)
		terminal_line.text = ""
