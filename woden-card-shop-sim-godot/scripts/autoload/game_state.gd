extends Node

var cash: int = 500
var inventory: Array[Item] = []

func can_afford(cost: int) -> bool:
	return cash >= cost

func place_order(item_id: String, quantity: int) -> bool:
	var catalog_item := ItemDatabase.get_item(item_id)
	if catalog_item == null:
		push_warning("Tried to order unknown item_id: %s" % item_id)
		return false

#TODO
#Make PlayerProgress
	if catalog_item.unlock_level > 0:#PlayerProgress.level:
		push_warning("Tried to order locked item: %s" % item_id)
		return false

	var total_cost := catalog_item.price * quantity
	if not can_afford(total_cost):
		return false

	cash -= total_cost
	_add_stock(catalog_item, quantity)
	return true

func _add_stock(catalog_item: Item, quantity: int) -> void:
	# Duplicate so we're not mutating the shared master resource loaded from disk
	var stock_item := catalog_item.duplicate() as Item
	stock_item.stock_quantity = quantity
	inventory.append(stock_item)
