extends Label

@onready var UsernameLabel = get_node("/root/App/UI/UsernameLabel")

@export var data: Resource

func _ready():
	usernameSet(data.name)

func usernameSet(local_name):
	data.name = local_name
	UsernameLabel.text = data.name

func _on_enter_button_update_name(newName):
	usernameSet(newName)
	data.saveData()
	
func _process(delta):
	pass
