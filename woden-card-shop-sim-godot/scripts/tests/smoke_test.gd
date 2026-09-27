extends Node
# Run this scene directly (F6) to run all smoke tests.
# Run in vscode via the command godot --path . scenes/tests/SmokeTest.tscn

var passed := 0
var failed := 0

func _ready() -> void:
	print("Loaded item ids: ", ItemDatabase.all_items.keys())
	print("---- Running smoke tests ----")
	_run_test("cart_add_and_submit", test_cart_add_and_submit)
	_run_test("cart_rejects_unknown_item", test_cart_rejects_unknown_item)
	print("---- Results: %d passed, %d failed ----" % [passed, failed])

func _run_test(test_name: String, test_fn: Callable) -> void:
	if test_fn.call():
		passed += 1
		print("PASS: %s" % test_name)
	else:
		failed += 1
		print("FAIL: %s" % test_name)

func _check(condition: bool, message: String) -> bool:
	if not condition:
		print("  -> %s" % message)
	return condition

# --- Tests ---

func test_cart_add_and_submit() -> bool:
	GameState.cash = 500
	GameState.inventory.clear()
	GameState.clear_cart()

	if not _check(GameState.add_to_cart("test_card", 2), "add_to_cart returned false"):
		return false

	var expected_total: int = ItemDatabase.get_item("test_card").price * 2
	if not _check(GameState.get_cart_total() == expected_total, "cart total mismatch"):
		return false

	if not _check(GameState.submit_order(), "submit_order returned false"):
		return false

	if not _check(GameState.inventory.size() == 1, "expected 1 inventory entry"):
		return false

	return _check(GameState.cash == 500 - expected_total, "cash not deducted correctly")

func test_cart_rejects_unknown_item() -> bool:
	GameState.clear_cart()
	return _check(not GameState.add_to_cart("this_id_does_not_exist", 1), "unknown item was added to cart")
