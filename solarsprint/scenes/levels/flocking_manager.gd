
extends Node

var enemies: Array = []

func register(enemy):
	if enemy not in enemies:
		enemies.append(enemy)
		enemy.flock = enemies

func unregister(enemy):
	enemies.erase(enemy)
