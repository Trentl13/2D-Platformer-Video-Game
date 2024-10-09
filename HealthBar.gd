extends ProgressBar

func _ready():
	Game.HealthChange.connect(_update)
	_update()
	
func _update():
	value = Game.playerCurrentHP * 100/ Game.playerHP
