extends Resource
#const DATA_PATH = "data/data.tres"
const DATA_PATH = "usr://data.tres"

@export var name: String

func saveData():
	ResourceSaver.save(self, DATA_PATH)
	print("saved!")

func loadData():
	ResourceLoader.load(DATA_PATH)
	print("loaded!")
