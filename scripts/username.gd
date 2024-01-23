extends Label

var username
const DEF_NAME = "user"
var filePath = "user://name.dat"

@onready var UsernameLabel = get_node("/root/App/UI/UsernameLabel")

func writeName(n):
	var writeNameFile = FileAccess.open(filePath,FileAccess.WRITE)
	writeNameFile.store_string(n)
	print_debug(n + " written")

func readName():
	if FileAccess.file_exists(filePath):
		var readNameFile = FileAccess.open(filePath,FileAccess.READ)
		username = readNameFile.get_as_text()
		if username == "":
			username = DEF_NAME
			writeName(DEF_NAME)
	else:
		print_debug("username file not found")
		writeName(DEF_NAME)
	print_debug(str(username) + " read")

func _ready():
	readName()
	usernameSet(username)

func usernameSet(n):
	writeName(n)
	UsernameLabel.text = n

func _on_enter_button_update_name(newName):
	usernameSet(newName)
	
