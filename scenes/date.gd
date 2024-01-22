extends Label

const MONTH_NAME_ARRAY = ["nut","jan","feb","mar","apr","may","jun","jul","aug","sep","oct","nov","dec"]
const MONTH_DUR_ARRAY = [0,31,29,31,30,31,30,31,31,30,31,30,31]

var month = MONTH_NAME_ARRAY[0];
var yearDay = 0;
func dateConcat():
	var dateTime = Time.get_datetime_dict_from_system()
	month = MONTH_NAME_ARRAY[dateTime['month']];
	
	for i in dateTime['month']:
		yearDay += MONTH_DUR_ARRAY[i]
		
	yearDay += dateTime['day']
	var date = '%s-%s' % [dateTime['day'],month]
	print (date) 
	print (yearDay) 

# Called when the node enters the scene tree for the first time.
func _ready():
	dateConcat()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
