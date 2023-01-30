extends CanvasLayer

signal start_game


func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()


func _on_MessageTimer_timeout():
	$Message.hide()


func _on_StartButton_pressed():
	$StartButton.hide()
	start_new_game_animation()


func start_new_game_animation():
	$MenuTractor.start_moving()
	$MenuChicken.start_moving()


func update_score(score):
	$ScoreLabel.text = str(score)


func update_life(life):
	$LifeLabel.text = str(life)
	if life <= 30:
		$LifeLabel.add_color_override("font_color", Color(1,0,0,1))
	elif life <= 70:
		$LifeLabel.add_color_override("font_color", Color(1,1,0,1))
	else:
		$LifeLabel.add_color_override("font_color", Color(0,1,0,1))


func show_player_stats():
	$ScoreLabel.show()
	$ScoreLabelName.show()
	$LifeLabel.show()
	$LifeLabelName.show()

func hide_player_stats():
	$ScoreLabel.hide()
	$ScoreLabelName.hide()
	$LifeLabel.hide()
	$LifeLabelName.hide()


func show_game_over():
	$Message.text = "It doesn't matter how fast they run. The  tractor is faster..."
	$Message.show()
	$MenuTractor.reset()
	$MenuChicken.reset()
	$StartButton.show()


func _on_MenuTractor_screen_exited():
	emit_signal("start_game")
