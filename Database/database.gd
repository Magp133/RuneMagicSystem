extends Node

var db
var db_name = "res://Database/MainDataBase"


#different inventory and object databases.
var material_cache: Dictionary = {}
var instruction_cache: Dictionary = {}
var rune_base_cache: Dictionary = {}
var saved_rune_cache: Dictionary = {}
var recipe_cache: Dictionary = {}

func _ready():
	db = SQLite.new()
	db.path = db_name
	db.open_db()
	
	populate_dictionary(material_cache, "Materials")
	populate_dictionary(instruction_cache, "Instructions")
	populate_dictionary(rune_base_cache, "Runes")
	populate_dictionary(saved_rune_cache, "SavedRunes")
	
	
func query_database(table_name):
	return db.query("select * from" + table_name + ";")

func populate_dictionary(input_dictionary: Dictionary, table_name: String):
	var data = query_database(table_name)
	
	for i in range(0, data.size()):
		pass