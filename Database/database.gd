extends Node

var db
var db_name = "res://Database/MainDataBase"

#different inventory and object databases.
var material_cache: Dictionary = {}
var rune_base_cache: Dictionary = {}
var sigil_cache: Dictionary = {}
var saved_rune_cache: Dictionary = {}
var recipe_cache: Dictionary = {}

func _ready():
	db = SQLite.new()
	db.path = db_name
	db.open_db()
	
	populate_dictionary(material_cache, "Materials")
	#populate_dictionary(rune_base_cache, "Runes")
	#populate_dictionary(saved_rune_cache, "SavedRunes")
	

func populate_dictionary(input_dictionary: Dictionary, table_name: String):
	db.query("select * from " + table_name + ";")
	var data = db.query_result
	
	for i in range(0, data.size()):
		input_dictionary[data[i]["Id"]] = data[i]
		
func commit_data(table_name: String, input_dictionary: Dictionary):
	db.insert_row(table_name, input_dictionary)
