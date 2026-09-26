extends Node

var all_items: Dictionary = {}  # item_id -> Item

func _ready() -> void:
	_load_items_in_dir("res://data/items/")

func _load_items_in_dir(path: String) -> void:
	var dir := DirAccess.open(path)
	if dir == null:
		return
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		var full_path := path.path_join(file_name)
		if dir.current_is_dir() and not file_name.begins_with("."):
			_load_items_in_dir(full_path)
		elif file_name.ends_with(".tres"):
			var item := load(full_path) as Item
			if item:
				all_items[item.item_id] = item
		file_name = dir.get_next()
	dir.list_dir_end()

func get_item(item_id: String) -> Item:
	return all_items.get(item_id)
