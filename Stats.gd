extends CanvasLayer

signal return_to_menu

var chicken = 0
var hay_rolls = 0
var pitchforks = 0
var scarecrows = 0
var fuel_canisters = 0
var game_time = 0
var death_bringer
var game_score = 0
var demise_adjectives = ["fast", "strong", "unpleasant", "beautiful", "sharp", "unexpected", "fatal", "mighty", "rude", "naughty", "mischievous", "merciless", "dominant", "unholy", "glorious", "fabulous", "indestructible"]
var ranks = ["Dead Bones", "Scared Crow", "Hay Bouncer", "Chick Magnet", "Tractor Lord", "Reaper of the Month"]

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()


func killed_mob(mob):
	if mob.type == "chicken":
		chicken += 1
	elif mob.type == "hay":
		hay_rolls += 1
	elif mob.type == "pitchfork":
		pitchforks += 1
	elif mob.type == "scarecrow":
		scarecrows += 1
	elif mob.type == "fuel":
		fuel_canisters += 1


func set_death_bringer(mob):
	death_bringer = mob


func set_game_time(time):
	game_time = time


func set_game_score(score):
	game_score = score


func load_stats_into_screen():
	$TotaRank.text = "Rank: " + ranks[clamp(int(game_score/2000), 0, ranks.size()-1)]
	$GameTime.text = "Reaping Time: " + str(game_time) + "s"
	$TotalScore.text = "Soul Score: " + str(game_score)
	$HarvestedMobs.text = "Poor Chickens: " + str(chicken) + "\n" + "Scarecrows: " + str(scarecrows) + "\n" + "Hay Rolls: " + str(hay_rolls) + "\n" + "Pitchforks: " + str(pitchforks) + "\n" + "Fuel Canisters: " + str(fuel_canisters)
	$DeathBringer.text = "Your Demise: " + demise_adjectives[randi() % demise_adjectives.size()].capitalize() + " " + str(death_bringer).capitalize()


func reset():
	chicken = 0
	hay_rolls = 0
	pitchforks = 0
	scarecrows = 0
	fuel_canisters = 0
	game_time = 0
	death_bringer = null


func _on_Restart_pressed():
	emit_signal("return_to_menu")
