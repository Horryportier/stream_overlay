extends Control

@onready var sun: DirectionalLight2D = %Sun
@onready var sun_timer: Timer = %SunTimer

@export var sun_color_over_time: Gradient


func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.TURQUOISE)


func _process(_delta: float) -> void:
	var sun_timer_noramlized: float = remap(sun_timer.time_left, 0, sun_timer.wait_time, 0, 1)
	sun.rotation = -remap(sun_timer_noramlized, 0, 1 ,  0, PI * 2)
	sun.color = sun_color_over_time.sample(sun_timer_noramlized)
