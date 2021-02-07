extends Node

var zoomyea = 0.1
onready var viewport = get_node("/root/Node/Panel/Board/viewport")

func _input(event):
	if Input.get_action_strength("zoom"):
		print("Zoom")
		$Camera2D.zoom.x = clamp($Camera2D.zoom.x - zoomyea, 0.1, 100)
		$Camera2D.zoom.y = clamp($Camera2D.zoom.y - zoomyea, 0.1, 100)
		
	elif Input.get_action_strength("unzoom"):
		$Camera2D.zoom.x = clamp($Camera2D.zoom.x + zoomyea, 0.1, 100)
		$Camera2D.zoom.y = clamp($Camera2D.zoom.y + zoomyea, 0.1, 100)

	if event is InputEventMouseMotion:
		if Input.is_action_pressed("pan"):
			$Camera2D.position -= event.relative * $Camera2D.zoom
func _process(delta):
	pass



func _on_Button_pressed():
	var file = $Camera2D/CanvasLayer/FileDialog
	file.set_filters(PoolStringArray(["*.png ; PNG Images"]))
	var popup = PopupDialog.new()
	file.popup()
	


func _on_FileDialog_file_selected(path):
	var filename = path
	print("Saving PNG")
	var img = viewport.get_texture().get_data()
	img.clear_mipmaps()
	var bg = get_node("/root/Node/Camera2D/CanvasLayer/VBoxContainer/PanelContainer/VBoxContainer/BackGroundColor").color
	var final_image = Image.new()
	final_image.create(viewport.size.x, viewport.size.y, false, Image.FORMAT_RGBA8)
	final_image.lock()
	final_image.fill(bg)
	final_image.blend_rect(img, Rect2(Vector2.ZERO, viewport.size), Vector2(0,0))
	final_image.unlock()
	
	var x = final_image.save_png(filename)
	print("Saved.")
