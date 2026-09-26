class_name Item
extends Resource

@export var item_name: String
@export var price: int
@export var texture: Texture2D      # small world/shelf icon
@export var detail_texture: Texture2D  # full art shown when examined
@export var stock_quantity: int = 1
@export var item_id: String
@export var unlock_level: int = 1  # store/player level required to order this
