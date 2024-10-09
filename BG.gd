extends ParallaxBackground

var scrollingSpeed = 100

func _process(delta):
	scroll_offset.x -= scrollingSpeed * delta #backgrounda se dviji nalqvo
