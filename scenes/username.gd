extends Label

const USER_NAME = "kono@konOS"

func usernameSet(name):
	var UsernameLabel = get_node("/root/App/UI/UsernameLabel")
	UsernameLabel.text = name

func _ready():
	usernameSet(USER_NAME)

func _process(delta):
	pass
