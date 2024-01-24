extends LineEdit

@onready var terminal_line = get_node("/root/App/UI/terminal-line")

signal update_user(newName:String)
signal update_macro(type:String,amount:int)
signal update_weight(newWeight:float)

func keywordEngine(command):
	var keywordArray = command.split(' ',false, 16)
	
	for i in keywordArray.size():
		keywordArray[i] = keywordArray[i].to_lower()
	
	if keywordArray.size() > 2:
		if (keywordArray[0] == "carb" or keywordArray[0] == "c") and (keywordArray[1] == "add" or keywordArray[1] == "a"):
			update_macro.emit("c",int(keywordArray[2])) 
		if (keywordArray[0] == "prot"  or keywordArray[0] == "p") and (keywordArray[1] == "add" or keywordArray[1] == "a"):
			update_macro.emit("p",int(keywordArray[2]))
			 
	if keywordArray.size() > 1:
		if keywordArray[0] == "kg" or keywordArray[0] == "k" or keywordArray[0] == "w"  or keywordArray[0] == "weight":
			update_weight.emit(float(keywordArray[1]))
			
		if keywordArray[0] == "user" or keywordArray[0] == "u" or keywordArray[0] == "name" or keywordArray[0] == "n":
			update_user.emit(keywordArray[1])

func _process(_delta):
	if Input.is_action_just_released("enter"):
		keywordEngine(terminal_line.text)
		terminal_line.text = ""
