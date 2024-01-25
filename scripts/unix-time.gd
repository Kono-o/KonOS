extends Label

@onready var unix_time_label = get_node("/root/App/UI/headers/unix-time-label")
func _process(delta):
	var unixTime = int(Time.get_unix_time_from_system())
	unix_time_label.text = str(unixTime)
	

