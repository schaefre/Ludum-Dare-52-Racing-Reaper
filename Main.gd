extends Node

export (PackedScene) var chicken_scene
export (PackedScene) var scarecrow_scene
export (PackedScene) var hay_scene
export (PackedScene) var fuel_scene
export (PackedScene) var pitch_fork_scene
export (PackedScene) var phone_scene
var scenes

export var tractor_speed = 200
export var tractor_acceleration =  1.05
var INITIAL_TRACTOR_SPEED = tractor_speed
var MAX_TRACTOR_SPEED = tractor_speed * 2

var score
var game_time 
var screen_size
const GRID_HEIGHT = 100
const GRID_LANE_START = [120, 300, 450]
const GRID_LANES = 3
export var player_grid_position = 1
const PLAYER_OFFSET_X = 200.0
var all_mobs = []
var is_game_running = false

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport().size
	randomize()
	scenes = [chicken_scene, scarecrow_scene, hay_scene, fuel_scene, pitch_fork_scene, phone_scene]
	$Field.hide()
	$Stats.hide()
	$HUD.hide_player_stats()
	$MenuBackground.show()


func new_game():
	$MenuBackground.hide()
	$Field.show()
	$Stats.reset()
	score = 0
	is_game_running = false
	$Player.life = $Player.MAX_LIFE
	game_time = 0
	all_mobs = []
	set_tractor_speed(0)
	$Player.start(Vector2(PLAYER_OFFSET_X, get_cell_center_y_for(player_grid_position)))
	$HUD.show_player_stats()
	$HUD.update_score(score)
	$HUD.update_life($Player.life)
	$HUD.show_message("Start your engine...")
	place_initial_mobs()
	$TractorEngineSound.play()
	if !$BackgroundMusic.is_playing():
		$BackgroundMusic.play()
	$StartTimer.start()


func place_initial_mobs():
	var scarecrow_lane = randi() % 3
	var mob
	for i in range(3):
		if i == scarecrow_lane:
			mob = scarecrow_scene.instance()
		else:
			mob = chicken_scene.instance() 
		mob.position = Vector2(rand_range(screen_size.x/2.0, screen_size.x - 50), get_cell_center_y_for(i))
		mob.idle()
		mob.connect("die", self, "_on_Mob_died")
		all_mobs.append(mob)
		add_child(mob)


func game_over():
	is_game_running = false
	$Field.hide()
	$MenuBackground.show()
	$MobTimer.stop()
	$GameTimer.stop()
	$Player.hide()
	get_tree().call_group("chickens", "queue_free")
	get_tree().call_group("scarecrow", "queue_free")
	get_tree().call_group("hay_rolls", "queue_free")
	get_tree().call_group("fuel_canisters", "queue_free")
	get_tree().call_group("pitchforks", "queue_free")
	get_tree().call_group("phones", "queue_free")
	$HUD.hide_player_stats()
	$HUD.hide()
	$Stats.set_game_time(game_time)
	$Stats.set_game_score(score)
	$Stats.load_stats_into_screen()
	$Stats.show()



func _on_Stats_return_to_menu():
	$Stats.hide()
	$HUD.show()
	$HUD.show_game_over()


func _on_StartTimer_timeout():
	is_game_running = true
	$MobTimer.start()
	$GameTimer.start()
	# Set all mobs to running
	for mob in all_mobs:
		mob.run()
	# Allow the tractor to start only after the game has begun
	set_tractor_speed(INITIAL_TRACTOR_SPEED)


func set_tractor_speed(speed):
	tractor_speed = clamp(speed, 0.1, MAX_TRACTOR_SPEED)
	$Field.set_movement_speed(speed)
	for mob in all_mobs:
		if is_instance_valid(mob):
			mob.linear_velocity.x = -speed + mob.get_speed()


func _on_GameTimer_timeout():
	game_time += 1
	if game_time == 15:
		$MobTimer.wait_time = 0.75
	elif game_time == 25:
		$MobTimer.wait_time = 0.5
	elif game_time == 45:
		$MobTimer.wait_time = 0.3

func spawn_mob_on_lane(mob_scene, lane):
	# Create new mob
	var mob = mob_scene.instance() 
	#mob.name = "mob" + str(mob.get_instance_id())
	
	# Set spawn location
	mob.position = Vector2(screen_size.x, get_cell_center_y_for(lane))
	
	# Set velocity relative to the tractor
	mob.linear_velocity.x = -tractor_speed + mob.get_speed()
	
	# Set mob to running
	if mob.type != "hay":
		mob.run()
	else:
		mob.idle()
	
	# Connect signal "die" of mob to _on_Mob_died that removes the given mob from all_mobs
	mob.connect("die", self, "_on_Mob_died")
	
	# Add mob to list of all mobs
	all_mobs.append(mob)
	
	# Add mob to the screen
	add_child(mob)


func _on_MobTimer_timeout():
	for lane in range(3):
		# 50% chance to spawn a mob on each lane
		if randi() % 2:
			var random_mob = randi() % 100
			var mob_scene
			if random_mob < 45:
				mob_scene = chicken_scene
			elif random_mob < 65:
				mob_scene = scarecrow_scene
			elif random_mob < 75:
				mob_scene = hay_scene
			elif random_mob < 90:
				mob_scene = pitch_fork_scene
			elif random_mob < 98:
				mob_scene = fuel_scene
			else:
				mob_scene = phone_scene
			spawn_mob_on_lane(mob_scene, lane)


func _on_Player_hit(mob):
	score += mob.get_score()
	$HUD.update_score(score)
	$Player.take_damage(mob.get_damage(), mob.get_type())
	$HUD.update_life($Player.life)
	$Stats.killed_mob(mob)
		
	if mob.type == "chicken":
		$ChickenSound.play()
	elif mob.type == "scarecrow":
		$ScarecrowSound.play()
	if mob.type == "hay":
		$HaySound.play()
		mob.run()
		mob.weight = 1000
		mob.linear_velocity.x = tractor_speed + mob.get_speed()
		mob.set_collision_mask_bit(0, true)
	elif mob.type == "fuel":
		$FuelSound.play()
		set_tractor_speed(tractor_speed * tractor_acceleration)
		mob.die()
	elif mob.type == "pitchfork":
		$PitchforkSound.play()
		mob.die()
	elif mob.type == "phone":
		$PhoneSound.play()
	else:
		mob.die()


func _on_Mob_died(mob):
	all_mobs.erase(mob)


func _on_Player_die(mob_type):
	$Stats.set_death_bringer(mob_type)
	$GameOverSound.play()
	game_over()


func _on_Player_full_health():
	pass # Replace with function body.


func get_cell_center_y_for(lane):
	#return screen_size.y/2 - GRID_OFFSET + (GRID_HEIGHT*lane) + GRID_HEIGHT/2.0
	return GRID_LANE_START[lane] + GRID_HEIGHT/2.0


func _on_Player_move_down():
	if is_game_running:
		player_grid_position = clamp(player_grid_position+1, 0, GRID_LANES-1)
		$Player.set_position(Vector2(PLAYER_OFFSET_X, get_cell_center_y_for(player_grid_position)))


func _on_Player_move_up():
	if is_game_running:
		player_grid_position = clamp(player_grid_position-1, 0, GRID_LANES-1)
		$Player.set_position(Vector2(PLAYER_OFFSET_X, get_cell_center_y_for(player_grid_position)))
