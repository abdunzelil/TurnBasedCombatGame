extends Node2D

var turn = 0
@onready var bosshp = $Boss/BossHPBar
@onready var playerhp = $Player/PlayerHPBar
@onready var playereffect = $Player/Label
@onready var bosseffect = $Boss/Label
@onready var slash_button = $Slash
@onready var fireball_button = $Fireball
@onready var heal_button = $Heal
@onready var turn_label = $Label
@onready var turn_timer = $Timer

func _ready():
	turn_label.visible = false
	playereffect.visible = false
	bosseffect.visible = false
	start_turn()

func start_turn():
	turn_timer.start(1.0)
	await turn_timer.timeout
	if bosshp.value <= 0:
		game_over("You Won!")
	elif playerhp.value <= 0:
		game_over("You Lost!")
	elif turn % 2 == 0:
		show_turn_label("Boss's Turn")
	else:
		show_turn_label("Your Turn")

func show_turn_label(text: String):
	turn_label.text = text
	turn_label.visible = true
	turn_timer.start(1.0)
	await turn_timer.timeout
	turn_label.visible = false
	if text == "Boss's Turn":
		boss_turn()
	else:
		player_turn()
		
		
func show_player_effect(text: String):
	playereffect.visible = true
	playereffect.text = text
	turn_timer.start(1.0)
	await turn_timer.timeout
	playereffect.visible = false
	
func show_boss_effect(text: String):
	bosseffect.visible = true
	bosseffect.text = text
	turn_timer.start(1.0)
	await turn_timer.timeout
	bosseffect.visible = false
	
func boss_turn():
	# Boss deals damage to player
	playerhp.value -= 5
	show_player_effect("-5 damage")
	turn += 1
	start_turn()

func player_turn():
	slash_button.disabled = false
	fireball_button.disabled = false
	heal_button.disabled = false

func end_player_turn():
	# Disable buttons after player makes a choice
	slash_button.disabled = true
	fireball_button.disabled = true
	heal_button.disabled = true
	turn += 1
	start_turn()

func _on_slash_pressed():
	bosshp.value -= 5
	show_boss_effect("-5 damage!")
	end_player_turn()

func _on_fireball_pressed():
	bosshp.value -= 10
	show_player_effect("-2 mana")
	show_boss_effect("-10 damage!")
	end_player_turn()

func _on_heal_pressed():
	playerhp.value += 10
	show_player_effect("+10 HP")
	end_player_turn()

func game_over(message: String):
	# Handle game over logic here
	print(message)
	get_tree().paused = true
	# You can add more game over UI/logic here
