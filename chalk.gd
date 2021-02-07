
extends Control

var _pen = null
var _prev_mouse_pos = Vector2()
var pencolor

var image = Image.new()
var texture = ImageTexture.new()
var firstFrameOrSomething = true

func _ready():
	var viewport = Viewport.new()
	var rect = get_rect()
	viewport.size = rect.size
	viewport.usage = Viewport.USAGE_2D
	viewport.render_target_clear_mode = Viewport.CLEAR_MODE_NEVER
	viewport.render_target_v_flip = true
	
	image.create(rect.size.x, rect.size.y, false, Image.FORMAT_RGBA8)
	image.lock()
	image.fill(Color.white)
	image.unlock()
	
	texture.create_from_image(image)
	
	_pen = Node2D.new()
	viewport.add_child(_pen)
	_pen.connect("draw", self, "_on_draw")
	viewport.set_transparent_background(true)
	viewport.name = "viewport"
	add_child(viewport)
	
	var bg = TextureRect.new()
	bg.set_texture(texture)
	bg.name = "bg"
	add_child(bg)
	
	var rt = viewport.get_texture()
	var board = TextureRect.new()
	board.set_texture(rt)
	board.name = "board"
	add_child(board)


func _process(delta):
	_pen.update()


func _on_draw():
	var mouse_pos = get_local_mouse_position()
	var pencolor = get_node("/root/Node/Camera2D/CanvasLayer/VBoxContainer/ColorPickerButton").color
	var size = get_node("/root/Node/Camera2D/CanvasLayer/VBoxContainer/PanelContainer2/SpinBox").value
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		_pen.draw_circle(mouse_pos, size / 2, pencolor)
		_pen.draw_line(mouse_pos, _prev_mouse_pos, pencolor, size)
	
	_prev_mouse_pos = mouse_pos

func _on_BackGroundColor_color_changed(color):
	image.lock()
	image.fill(color)
	image.unlock()
	texture.create_from_image(image)
