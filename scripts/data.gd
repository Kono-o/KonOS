extends Resource
const DATA_PATH = "data/data.tres"

@export var name: String

func saveData():
	ResourceSaver.save(self, DATA_PATH)
	print("saved!")
