extends Node

var total_coins = 0
var player_lives = 3
enum PlayerState { SMALL, BIG, FIRE }
var current_state = PlayerState.SMALL

func spawn_beer_bottle(pos):
	var BeerBottleScene = load("res://beer.tscn")
	var beer_bottle = BeerBottleScene.instantiate()
	beer_bottle.global_position = pos
	get_tree().root.add_child(beer_bottle)

func spawn_fire_flower(pos):
	var FireFlowerScene = load("res://fire_flower.tscn")
	var fire_flower = FireFlowerScene.instantiate()
	fire_flower.global_position = pos
	get_tree().root.add_child(fire_flower)
