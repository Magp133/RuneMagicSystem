extends Node

#database setup
var db
var db_name = "res://Database/MainDataBase"

# Called when the node enters the scene tree for the first time.
func _ready():
	db = SQLite.new()
	db.path = db_name
	db.open_db()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
