extends Control

@onready var sun: DirectionalLight2D = %Sun
@onready var sun_timer: Timer = %SunTimer
@onready var green_screen: ColorRect  = %GreenScreen

@export var sun_color_over_time: Gradient


func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.TURQUOISE)
	Net.command_request.connect(_on_parse_net_request)


func _process(_delta: float) -> void:
	var sun_timer_noramlized: float = remap(sun_timer.time_left, 0, sun_timer.wait_time, 0, 1)
	sun.rotation = -remap(sun_timer_noramlized, 0, 1 ,  0, PI * 2)
	sun.color = sun_color_over_time.sample(sun_timer_noramlized)

func _on_parse_net_request(type: int, data: Dictionary) -> void:
	print(data)
	if type != Net.SET_GREENS_SCREEN_VISIBILITY:
		return
	green_screen.visible = data.get("visible", true)
