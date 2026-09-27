extends Node

var cash: int = 500
var inventory: Array[Item] = []
var cart: Dictionary = {}  # item_id -> quantity

func can_afford(cost: int) -> bool:
	return cash >= cost

func add_to_cart(item_id: String, quantity: int) -> bool:
	if quantity <= 0:
		return false

	var catalog_item := ItemDatabase.get_item(item_id)
	if catalog_item == null:
		push_warning("Tried to add unknown item_id to cart: %s" % item_id)
		return false

	if catalog_item.unlock_level > 0:  # TODO: replace 0 with PlayerProgress.level once that exists
		push_warning("Tried to add locked item to cart: %s" % item_id)
		return false

	cart[item_id] = cart.get(item_id, 0) + quantity
	return true

func remove_from_cart(item_id: String, quantity: int = -1) -> void:
	if not cart.has(item_id):
		return
	if quantity < 0 or quantity >= cart[item_id]:
		cart.erase(item_id)
	else:
		cart[item_id] -= quantity

func clear_cart() -> void:
	cart.clear()

func get_cart_total() -> int:
	var total := 0
	for item_id in cart:
		var catalog_item := ItemDatabase.get_item(item_id)
		if catalog_item:
			total += catalog_item.price * cart[item_id]
	return total

func submit_order() -> bool:
	# Validate everything before touching cash or inventory
	for item_id in cart:
		var catalog_item := ItemDatabase.get_item(item_id)
		if catalog_item == null:
			push_warning("Cart contains unknown item_id: %s" % item_id)
			return false
		if catalog_item.unlock_level > 0:  # TODO: replace 0 with PlayerProgress.level once that exists
			push_warning("Cart contains locked item: %s" % item_id)
			return false

	var total_cost := get_cart_total()
	if not can_afford(total_cost):
		return false

	cash -= total_cost
	for item_id in cart:
		var catalog_item := ItemDatabase.get_item(item_id)
		var quantity: int = cart[item_id]
		_add_stock(catalog_item, quantity)

	clear_cart()
	return true

func _add_stock(catalog_item: Item, quantity: int) -> void:
	var stock_item := catalog_item.duplicate() as Item
	stock_item.stock_quantity = quantity
	inventory.append(stock_item)