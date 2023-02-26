extends NinePatchRect

signal dialog_finished

export var dialog = ""
export(float) var TEXT_SPEED = 0.05

onready var nameLabel : Label = $GridContainer/GridContainer/Name
onready var textContent : RichTextLabel = $GridContainer/GridContainer/Dialogue
onready var portrait : TextureRect = $GridContainer/Picture

var phraseNum = 0
var finished = false


func _ready():
	$Timer.wait_time = TEXT_SPEED
	#print(dialogPath)
	#dialog = getDialog()
	dialog = parse_json(dialog)
	assert(dialog, "Dialog not found")
	nextPhrase()
	
func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		if finished:
			nextPhrase()
		else:
			textContent.visible_characters = len(textContent.text)
 
func getDialog():
	var f = File.new()
	#assert(f.file_exists(dialogPath), "File path does not exist")
	
	#f.open(dialogPath, File.READ)
	var json = f.get_as_text()
	print(json)
	var output = parse_json(json)
	print(output)
	if typeof(output) == TYPE_ARRAY:
		return output
	else:
		return []
		
func nextPhrase() -> void:
	if phraseNum >= len(dialog):
		emit_signal("dialog_finished")
		queue_free()
		return
	
	finished = false
	
	
	nameLabel.text = dialog[phraseNum]["Name"]
	textContent.bbcode_text = dialog[phraseNum]["Text"]
	
	textContent.visible_characters = 0
	   
	var f = File.new()
	var img = dialog[phraseNum]["Name"] + ".png"
	if f.file_exists(img):
		portrait.texture = load(img)
	else: portrait.texture = null
	
	while textContent.visible_characters < len(textContent.text):
		textContent.visible_characters += 1
		
		$Timer.start()
		yield($Timer, "timeout")
	
	finished = true
	phraseNum += 1
	return
